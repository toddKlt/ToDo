//
//  ViewController.swift
//  ToDo
//
//  Created by Theodoros Kaltikopoulos on 04/09/2018.
//  Copyright © 2018 mania. All rights reserved.
//

import UIKit
import RealmSwift
import  SwipeCellKit

class ToDoVC: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ToDoVC {
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            // set value of cell.accessoryType to .checkmark or .none depending on the value true/false of item.done
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
//                    realm.delete(item)
                }
            } catch {
                print("Erros saving done status, \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Add New Items -
extension ToDoVC {
    @IBAction func addBtnPressed (_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        // pull items from current category item list and append them
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Load items to Realm
    func loadItems () {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - Search bar Method
extension ToDoVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        // [cd] case / diacritic INSENSITIVE
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
//        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            // [cd] case / diacritic INSENSITIVE
            todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true).filter("title CONTAINS[cd] %@", searchText)
//            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
        }
    }
}
