//
//  ViewController.swift
//  ToDo
//
//  Created by Theodoros Kaltikopoulos on 04/09/2018.
//  Copyright © 2018 mania. All rights reserved.
//

import UIKit
import CoreData

class ToDoVC: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//    var itemArray = Array<String>()//["Mike", "Eggs", "Demogorgon"]
//    let testArray = ["Mike", "Eggs", "Demogorgon"]
//    let defaults = UserDefaults.standard
//    var itemArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        for name in testArray {
//            let newItem = Item()
//            newItem.title = name
//            newItem.done = false
//            itemArray.append(newItem)
//        }
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
    }
}

extension ToDoVC {
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // set value of cell.accessoryType to .checkmark or .none depending on the value true/false of item.done
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        //delete first the row at indexpath from context list and then from the itemArray list
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Search bar Method
extension ToDoVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
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
        }
    }
}

//MARK: - Add New Items
extension ToDoVC {
    @IBAction func addBtnPressed (_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add button
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Save/Update items to Core Data
    func saveItems () {
        do {
            try context.save()
            print("saving...")
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
        print("reloading data...")
    }
    
    //MARK: - Load items to Core Data
    func loadItems (with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from contect \(error)")
        }
        
        tableView.reloadData()
    }
    
    //    func saveItems () {
    //        let encoder = PropertyListEncoder()
    //        do {
    //            let data = try encoder.encode(itemArray)
    //            try data.write(to: dataFilePath!)
    //            tableView.reloadData()
    //        } catch {
    //            print("Error encoding item array!, \(error)")
    //        }
    //    }
    //
    //    func loadItems () {
    //        if let data = try? Data(contentsOf: dataFilePath!) {
    //            let decoder = PropertyListDecoder()
    //            do {
    //                itemArray = try decoder.decode([Item].self, from: data)
    //            } catch {
    //                print("Error decoding item array!, \(error)")
    //            }
    //        }
    //    }
}

