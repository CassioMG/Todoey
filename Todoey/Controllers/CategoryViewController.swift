//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Cássio Marcos Goulart on 08/05/19.
//  Copyright © 2019 CMG Solutions. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    // MARK: - Instance variables
    let realm = try! Realm()
    var categories: Results<Category>!
    
    // MARK: - Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set the default navigation bar color for the app
        updateNavigationBar(withFlatColor: FlatSkyBlue())
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.title
        cell.backgroundColor = HexColor(category.backgroundHexColor)
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Data manipulation
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving Categories: \(error)")
        }
        
        tableView.reloadData()
    }
    
    override func deleteData(at indexPath: IndexPath) {
        
        if indexPath.row >= categories.count {
            print("Couldn't delete data at indexPath: \(indexPath)")
            return
        }
        
        do {
            try realm.write {
                realm.delete(categories[indexPath.row])
            }
        } catch {
            print("Error deleting object from Realm: \(error)")
        }
    }
    
    // MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newCategoryTextField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { _ in
            
            let newCategory = Category()
            newCategory.title = newCategoryTextField.text!
            newCategory.backgroundHexColor = RandomFlatColor().hexValue()
            self.save(category: newCategory)
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Create new category"
            newCategoryTextField = textField
        }
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToItems" {
            
            let selectedCategory = categories[tableView.indexPathForSelectedRow!.row]
            let todoListVC = (segue.destination as! TodoListViewController)
            
            todoListVC.title = selectedCategory.title
            todoListVC.parentCategory = selectedCategory
        }
    }
    

}
