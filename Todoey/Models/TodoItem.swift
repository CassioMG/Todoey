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
    
    @objc dynamic var done = false
    
    let category = LinkingObjects(fromType: Category.self, property: "items")
    
}
