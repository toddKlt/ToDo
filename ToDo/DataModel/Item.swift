//
//  Item.swift
//  ToDo
//
//  Created by Theodoros Kaltikopoulos on 28/09/2018.
//  Copyright © 2018 mania. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date? // = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
