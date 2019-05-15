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
    
    @objc dynamic var dateCreated = Date()
    @objc dynamic var title = ""
    @objc dynamic var backgroundHexColor = "#FFFFFF"
    
}
