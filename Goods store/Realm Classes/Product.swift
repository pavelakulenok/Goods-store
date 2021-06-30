//
//  Product.swift
//  Goods store
//
//  Created by Pavel Akulenak on 26.06.21.
//

import RealmSwift

class Product: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var quantity: Int = 0
    let productTransactions = List<ProductTransaction>()
}
