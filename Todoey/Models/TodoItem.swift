//
//  TodoItem.swift
//  Todoey
//
//  Created by Cássio Marcos Goulart on 06/05/19.
//  Copyright © 2019 CMG Solutions. All rights reserved.
//

import UIKit

class TodoItem: Codable {

    var title : String
    var done : Bool

    init(itemTitle: String) {
        title = itemTitle
        done = false
    }
    
}
