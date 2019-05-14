//
//  Category.swift
//  Todoey
//
//  Created by Cássio Marcos Goulart on 08/05/19.
//  Copyright © 2019 CMG Solutions. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name = ""
    
    let items = List<TodoItem>()
    
}
