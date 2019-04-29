//
//  Item.swift
//  Todoey
//
//  Created by Mohammed Abouarab on 4/26/19.
//  Copyright © 2019 Mohammed Abouarab. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
