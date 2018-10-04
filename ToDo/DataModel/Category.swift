//
//  Category.swift
//  ToDo
//
//  Created by Theodoros Kaltikopoulos on 28/09/2018.
//  Copyright © 2018 mania. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
//    @objc dynamic var done: Bool = false
}
