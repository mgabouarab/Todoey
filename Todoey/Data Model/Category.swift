//
//  Category.swift
//  Todoey
//
//  Created by Mohammed Abouarab on 4/26/19.
//  Copyright © 2019 Mohammed Abouarab. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
