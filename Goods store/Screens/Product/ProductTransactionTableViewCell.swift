//
//  ProductTransactionTableViewCell.swift
//  Goods store
//
//  Created by Pavel Akulenak on 29.06.21.
//

import UIKit

class ProductTransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
