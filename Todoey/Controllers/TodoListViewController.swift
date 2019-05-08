//
//  ViewController.swift
//  Todoey
//
//  Created by Cássio Marcos Goulart on 04/05/19.
//  Copyright © 2019 CMG Solutions. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    // MARK: - Instance Variables
    var itemsArray = [TodoItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var parentCategory : Category? {didSet { loadItems() }}
    
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment this to discover in which folder your data is being stored in the system
        /*
         let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         print(dataFilePath)
         */
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
        
        saveItems(reloadData: false)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add New Items to the Todo List
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { _ in
            
            let newItem = TodoItem(context: self.context)
            newItem.title = textField.text!
            newItem.parentCategory = self.parentCategory
            
            self.itemsArray.append(newItem)
            self.saveItems()
        }
        
        alertController.addTextField { (alertTextField) in
            
            textField = alertTextField
            textField.placeholder = "Create new item"
        }
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
 
    // MARK: - Model Manipulation
    func saveItems (reloadData: Bool? = true) {
        
        do {
            try context.save()
        } catch {
            print("ERROR SAVING ITEMS ARRAY FROM CONTEXT: ", error)
        }
        
        if reloadData == true {
            tableView.reloadData()
        }
    }
    
    func loadItems (with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), compoundPredicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", parentCategory!.name!)
        
        if compoundPredicate != nil {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, compoundPredicate!])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemsArray = try context.fetch(request)

        } catch {
            print("ERROR FETCHING ITEMS ARRAY FROM CONTEXT: ", error)
        }
        
        tableView.reloadData()
    }
    
    
}

// MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, compoundPredicate: NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!))
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
