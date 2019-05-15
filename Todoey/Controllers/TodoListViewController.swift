//
//  ViewController.swift
//  Todoey
//
//  Created by Cássio Marcos Goulart on 04/05/19.
//  Copyright © 2019 CMG Solutions. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    // MARK: - Instance Variables
    let realm = try! Realm()
    var parentCategory : Category? {didSet {loadItems() }}
    var todoItems: Results<TodoItem>!
    
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment this to discover in which folder your data is being stored in the system
        /*
         let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         print(dataFilePath)
         
         print(Realm.Configuration.defaultConfiguration.fileURL!)
         */
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = todoItems[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        cell.backgroundColor = HexColor(item.backgroundHexColor)
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = todoItems[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        
        if item.done {
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
        }
        
        do {
            try realm.write {
                item.done = !item.done
            }
        } catch {
            print("Error editing item: \(error)")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add New Items to the Todo List
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { _ in
            
            if let currentCategory = self.parentCategory {

                do {
                    try self.realm.write {
                        let newItem = TodoItem()
                        newItem.title = textField.text!
                        newItem.backgroundHexColor = RandomFlatColor().hexValue()
                        currentCategory.items.append(newItem)
                        
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    print("Error writing new Todo Item: \(error)")
                }
            }
            
        }
        
        alertController.addTextField { (alertTextField) in
            
            textField = alertTextField
            textField.placeholder = "Create new item"
        }
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
 
    // MARK: - Model Manipulation
    func loadItems () {
        
        todoItems = parentCategory?.items.filter(NSPredicate(value: true))
        
        tableView.reloadData()
    }
    
    
    override func deleteData(at indexPath: IndexPath) {
        
        if indexPath.row >= todoItems.count {
            print("Couldn't delete data at indexPath: \(indexPath)")
            return
        }
        
        do {
            try realm.write {
                realm.delete(todoItems[indexPath.row])
            }
        } catch {
            print("Error deleting object from Realm: \(error)")
        }
    }
    
}

// MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                
        todoItems = todoItems.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.count == 0 {

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }


}
