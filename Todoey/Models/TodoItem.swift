//
//  TodoItem.swift
//  Todoey
//
//  Created by Cássio Marcos Goulart on 08/05/19.
//  Copyright © 2019 CMG Solutions. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated: Date = Date()
    
    let category = LinkingObjects(fromType: Category.self, property: "items")
    
}
