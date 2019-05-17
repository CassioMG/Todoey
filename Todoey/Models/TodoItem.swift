//
//  TodoItem.swift
//  Todoey
//
//  Created by Cássio Marcos Goulart on 08/05/19.
//  Copyright © 2019 CMG Solutions. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: TodoeyCell {
    
    // is this item done?
    @objc dynamic var done = false
    
    // relational reference to the category related to its item
    let category = LinkingObjects(fromType: Category.self, property: "items")
    
}
