//
//  Data.swift
//  ToDo
//
//  Created by Theodoros Kaltikopoulos on 19/09/2018.
//  Copyright © 2018 mania. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    //dynamic variable is monitored during runtime for changes
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
