//
//  Item.swift
//  Todoey
//
//  Created by Adam Malpass on 2019/09/07.
//  Copyright © 2019 Adam Malpass. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object
{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

}
