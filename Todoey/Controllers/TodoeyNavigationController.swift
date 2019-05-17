//
//  ContrastingNavigationController.swift
//  Todoey
//
//  Created by Cássio Marcos Goulart on 15/05/19.
//  Copyright © 2019 CMG Solutions. All rights reserved.
//

import UIKit
import ChameleonFramework

class TodoeyNavigationController: UINavigationController {
    
    // Let the view controller on top of the stack to choose the status bar style (light or default/black)
    override var childForStatusBarStyle: UIViewController? { return topViewController }
    
}
