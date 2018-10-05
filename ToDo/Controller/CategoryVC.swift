//
//  CategoryVC.swift
//  ToDo
//
//  Created by Theodoros Kaltikopoulos on 18/09/2018.
//  Copyright © 2018 mania. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryVC: UITableViewController {
    
    let realm = try! Realm()
//    Results is an auto-updating container type in Realm returned from object queries.
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80.0
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategory (category: Category) {
        // category is auto updated
        do {
            try realm.write {
                realm.add(category)
            }
            print("saving...")
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
        print("reloading data...")
    }
    
    //MARK: - Load items to Realm
    func loadCategories () {
        // load all category records from Category Object in Realm
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Add New Methods
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen once the user clicks the add button
            let newCategory = Category()
            newCategory.name = textField.text!
            self.saveCategory(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

//MARK: - Swipe Cell Delegate Methods
extension CategoryVC: SwipeTableViewCellDelegate {
    // MARK: - tableView datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if categories is nil return 1
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCategory", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added"
        cell.delegate = self
        // set value of cell.accessoryType to .checkmark or .none depending on the value true/false of item.done
        return cell
    }
    // MARK: - tableView delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems"{
            let destinationVC = segue.destination as! ToDoVC
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let categoryToDelete = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryToDelete)
                    }
                } catch {
                    print("Error deleting item, \(error)")
                }
//                tableView.reloadData()
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
