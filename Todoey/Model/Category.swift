//
//  Category.swift
//  Todoey
//
//  Created by Adam Malpass on 2019/09/07.
//  Copyright © 2019 Adam Malpass. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object
{
    @objc dynamic var name: String = ""
    @objc dynamic var backgroundColour : String?
    let items = List<Item>()
    
}
