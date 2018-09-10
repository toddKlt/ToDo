//
//  ViewController.swift
//  ToDo
//
//  Created by Theodoros Kaltikopoulos on 04/09/2018.
//  Copyright © 2018 mania. All rights reserved.
//

import UIKit

class MainVC: UITableViewController {

//    var itemArray = Array<String>()//["Mike", "Eggs", "Demogorgon"]
//    let testArray = ["Mike", "Eggs", "Demogorgon"]
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

//    let defaults = UserDefaults.standard
//    var itemArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        //"file:///var/mobile/Containers/Data/Application/2BF68D2A-134F-42A0-A1AA-0F5E7AC76FD5/Documents/"
        
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

    //MARK - TableView Datasource Methods 
    
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
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
    }
    
    //MARK - Add New Items
    @IBAction func addBtnPressed (_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add button
            let newItem = Item()
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems () {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            tableView.reloadData()
        } catch {
            print("Error encoding item array!, \(error)")
        }
    }
    
    func loadItems () {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array!, \(error)")
            }
        }
        
    }
}

