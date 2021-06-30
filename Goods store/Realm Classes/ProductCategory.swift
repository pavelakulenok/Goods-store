//
//  ProductCategory.swift
//  Goods store
//
//  Created by Pavel Akulenak on 26.06.21.
//

import RealmSwift

class ProductCategory: Object {
    @objc dynamic var name: String = ""
    let product = List<Product>()
}
