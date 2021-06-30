//
//  TransactionTableViewCell.swift
//  Goods store
//
//  Created by Pavel Akulenak on 29.06.21.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addBorderWidth(1)
    }
}
