//
//  ViewController.swift
//  Todoey
//
//  Created by Cássio Marcos Goulart on 04/05/19.
//  Copyright © 2019 CMG Solutions. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    // MARK: - Instance Variables
    var itemsArray = [TodoItem]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItemsFromFile()
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemsArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemsArray[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if item.done {
           cell?.accessoryType = .none
        } else {
           cell?.accessoryType = .checkmark
        }
        
        item.done = !item.done
        
        saveItemsToFile()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add New Items to the Todo List
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { _ in
            
            let newItem = TodoItem(itemTitle: textField.text!)
            self.itemsArray.append(newItem)
            
            self.saveItemsToFile()

            self.tableView.reloadData()
        }
        
        alertController.addTextField { (alertTextField) in
            
            textField = alertTextField
            textField.placeholder = "Create new item"
        }
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
 
    // MARK: - Model Manipulation
    func saveItemsToFile () {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemsArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            print("ERROR ENCODING ITEMS ARRAY: ", error)
        }
    }
    
    func loadItemsFromFile () {
        
        if let data = try? Data.init(contentsOf: dataFilePath!) {
        
            let decoder = PropertyListDecoder()
            
            do {
                itemsArray = try decoder.decode([TodoItem].self, from: data)
            } catch {
                print("ERROR DENCODING ITEMS ARRAY: ", error)
            }
            
        }
    }
    
}

