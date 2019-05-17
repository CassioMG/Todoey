//
//  TodoeyCell.swift
//  Todoey
//
//  Created by Cássio Marcos Goulart on 15/05/19.
//  Copyright © 2019 CMG Solutions. All rights reserved.
//

import Foundation
import RealmSwift

class TodoeyCell: Object {
    
    // all todoey cells should have a title and a date created
    @objc dynamic var title = ""
    @objc dynamic var dateCreated = Date()
    
}
