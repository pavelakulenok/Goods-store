//
//  ViewController.swift
//  Goods store
//
//  Created by Pavel Akulenak on 25.06.21.
//

import RealmSwift
import UIKit

class MainScreen: UIViewController {
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var statisticsButton: UIButton!
    @IBOutlet weak var transactionsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
        setupUI()
    }

    @IBAction private func onStoreButton(_ sender: Any) {
        let viewController = CategoriesViewController.instantiate()
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction private func onStatisticsButton(_ sender: Any) {
        let viewController = StatisticsViewController.instantiate()
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction private func onTransactionsButton(_ sender: Any) {
        let viewController = TransactionsViewController.instantiate()
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func setupUI() {
        storeButton.applyCornerRadius(25)
        storeButton.addShadow(color: .label, opacity: 1, offSet: .zero, radius: 10)
        statisticsButton.applyCornerRadius(25)
        statisticsButton.addShadow(color: .label, opacity: 1, offSet: .zero, radius: 10)
        transactionsButton.applyCornerRadius(25)
        transactionsButton.addShadow(color: .label, opacity: 1, offSet: .zero, radius: 10)
    }
}
