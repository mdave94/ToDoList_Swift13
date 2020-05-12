//
//  Category.swift
//  Todoey
//
//  Created by David on 2020. 05. 11..
//  Copyright © 2020. App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
