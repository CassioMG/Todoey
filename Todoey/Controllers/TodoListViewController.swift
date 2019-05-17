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
    var todoItems: Results<TodoItem>!
    var parentCategory : Category? { didSet { loadItems() } }
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment this to discover in which folder your data is being stored in the system
        // print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        // set the items list navigation bar color as the category color
        let navBarColor = HexColor(parentCategory!.backgroundHexColor)!
        updateNavigationBar(withFlatColor: navBarColor)
        
        // set the add button and search bar colors accordingly to the navigation bar color
        addButton.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = navBarColor
        searchBar.tintColor = navBarColor
    }

    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = todoItems[indexPath.row]
        let gradientBGColor = HexColor(parentCategory!.backgroundHexColor)?.darken(byPercentage: CGFloat(indexPath.row + 1) / CGFloat(2 * todoItems.count))
        let contrastingBGColor = ContrastColorOf(gradientBGColor!, returnFlat: true)
        
        cell.textLabel?.text = item.title
        cell.backgroundColor = gradientBGColor
        cell.tintColor = contrastingBGColor
        cell.textLabel?.textColor = contrastingBGColor
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
        
            let item = todoItems[indexPath.row]
            cell.accessoryType = item.done ? .none : .checkmark
            
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error editing item: \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add New Item to the Todo List
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { _ in
            
            if let currentCategory = self.parentCategory {

                do {
                    try self.realm.write {
                        let newItem = TodoItem()
                        newItem.title = textField.text!
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
            textField.autocapitalizationType = .words
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

        // clear search when the "x" button is tapped
        if searchText.count == 0 {

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }


}
