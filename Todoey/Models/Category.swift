//
//  Category.swift
//  Todoey
//
//  Created by Cássio Marcos Goulart on 08/05/19.
//  Copyright © 2019 CMG Solutions. All rights reserved.
//

import Foundation
import RealmSwift

class Category: TodoeyCell {
    
    // store the category background color, which will be used for its item list gradient colors
    @objc dynamic var backgroundHexColor = "#FFFFFF"
    
    // relational reference to the items list related to its category
    let items = List<TodoItem>()
    
}
