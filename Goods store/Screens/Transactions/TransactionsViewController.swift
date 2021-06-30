//
//  TransactionsViewController.swift
//  Goods store
//
//  Created by Pavel Akulenak on 26.06.21.
//

import RealmSwift
import UIKit

class TransactionsViewController: UIViewController {
    private var transactions = [ProductTransaction]()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var transactionsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transactions"
        do {
            let realm = try Realm()
            transactions = realm.objects(ProductTransaction.self).sorted { $0.date > $1.date }
        } catch {
            assertionFailure()
        }
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
        transactionsTableView.register(UINib(nibName: "TransactionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
    }

    @IBAction private func changeSegmentedControl(_ sender: Any) {
        do {
            let realm = try Realm()
            if segmentedControl.selectedSegmentIndex == 0 {
                transactions = realm.objects(ProductTransaction.self).sorted { $0.date > $1.date }
            } else if segmentedControl.selectedSegmentIndex == 1 {
                transactions = realm.objects(ProductTransaction.self).sorted { $0.date > $1.date }.filter { $0.type == "purchase" }
            } else {
                transactions = realm.objects(ProductTransaction.self).sorted { $0.date > $1.date }.filter { $0.type == "sale" }
            }
        } catch {
            assertionFailure()
        }
        transactionsTableView.reloadData()
    }
}

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = transactionsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TransactionTableViewCell else {
            return UITableViewCell()
        }
        cell.dateLabel.text = transactions[indexPath.row].date
        cell.nameLabel.text = transactions[indexPath.row].name
        cell.quantityLabel.text = "Quantity: \(transactions[indexPath.row].quantity)"
        cell.priceLabel.text = "Price: \(transactions[indexPath.row].price)"
        cell.amountLabel.text = "Transaction amount: \(Double(transactions[indexPath.row].quantity) * transactions[indexPath.row].price)"
        if transactions[indexPath.row].type == "purchase" {
            cell.typeLabel.text = "purchase"
            cell.typeLabel.textColor = .green
        } else {
            cell.typeLabel.text = "sale"
            cell.typeLabel.textColor = .red
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
