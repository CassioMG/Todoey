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
    let itemsArray = ["Buy Groceries", "Watch Avengers", "Go to School", "Play Fooball", "Eat Icecream"]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row]
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
           cell?.accessoryType = .none
        } else {
           cell?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
}

