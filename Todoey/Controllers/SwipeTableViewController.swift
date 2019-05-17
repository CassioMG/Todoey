//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Cássio Marcos Goulart on 14/05/19.
//  Copyright © 2019 CMG Solutions. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    // MARK: - Status Bar Style
    // Choose the best status bar style: white for dark backgrounds and black(default) for light backgrounds.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let navBarColor = navigationController?.navigationBar.barTintColor else { return .default }
        
        let contrastingStatusBarColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        return contrastingStatusBarColor == FlatWhite() ? .lightContent : .default
    }
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesNavigationBarHairline = true
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }

    // MARK: - Table View data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Table View delegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        // handle action by updating model with deletion
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteData(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        // set the expansio style for the swipe gesture to be destructive (delete action)
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        
        return options
    }

    // MARK: - Model manipulation
    func deleteData(at indexPath: IndexPath) {
        // Override this method at the sub class to delete data accordingly to the selected index path.
    }
    
    // MARK: - View manipulation
    // Set the navigation bar background color and choose the best contrasting color to its elements so that the reading gets comfortable.
    func updateNavigationBar(withFlatColor navBarColor: UIColor) {
        
        let navBarContrastColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navigationController?.navigationBar.tintColor = navBarContrastColor
        navigationController?.navigationBar.barTintColor = navBarColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : navBarContrastColor]
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
}
