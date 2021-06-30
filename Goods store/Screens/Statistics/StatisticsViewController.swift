//
//  StatisticsViewController.swift
//  Goods store
//
//  Created by Pavel Akulenak on 26.06.21.
//

import RealmSwift
import UIKit

class StatisticsViewController: UIViewController {
    private var transactions: Results<ProductTransaction>?

    @IBOutlet weak var purchasedGoodsWorthLabel: UILabel!
    @IBOutlet weak var goodsSoldForTheAmountLabel: UILabel!
    @IBOutlet weak var revenueFromSalesLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Statistics"
        navigationController?.navigationBar.tintColor = .label
        setupUI()
        do {
            let realm = try Realm()
            transactions = realm.objects(ProductTransaction.self)
        } catch {
            assertionFailure()
        }
        guard let transactions = transactions else {
            assertionFailure()
            return
        }
        var purchasedGoodsWorth: Double = 0
        var goodsSoldForTheAmount: Double = 0
        for transaction in transactions {
            if transaction.type == "purchase" {
                purchasedGoodsWorth += transaction.price * Double(transaction.quantity)
            } else if transaction.type == "sale" {
                goodsSoldForTheAmount += transaction.price * Double(transaction.quantity)
            }
        }
        purchasedGoodsWorthLabel.text = "Purchased goods worth: $\(purchasedGoodsWorth)"
        goodsSoldForTheAmountLabel.text = "Goods sold for the amount: $\(goodsSoldForTheAmount)"
        revenueFromSalesLabel.text = "Revenue from sales: $\(goodsSoldForTheAmount - purchasedGoodsWorth)"
    }

    private func setupUI() {
        purchasedGoodsWorthLabel.applyCornerRadius(10)
        purchasedGoodsWorthLabel.addBorderWidth(1)
        goodsSoldForTheAmountLabel.applyCornerRadius(10)
        goodsSoldForTheAmountLabel.addBorderWidth(1)
        revenueFromSalesLabel.applyCornerRadius(10)
        revenueFromSalesLabel.addBorderWidth(1)
    }
}
