//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Cássio Marcos Goulart on 08/05/19.
//  Copyright © 2019 CMG Solutions. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    // MARK: - Instance variables
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name

        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // MARK: - Data manipulation
    func loadCategories () {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching Categories: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveCategories () {
        
        do {
            try context.save()
        } catch {
            print("Error saving Categories: \(error)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newCategoryTextField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { _ in
            
            let newCategory = Category(context: self.context)
            newCategory.name = newCategoryTextField.text!
            
            self.categories.append(newCategory)
            self.saveCategories()
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
            
            todoListVC.navigationItem.title = selectedCategory.name
            todoListVC.parentCategory = selectedCategory
        }
    }
    

}
