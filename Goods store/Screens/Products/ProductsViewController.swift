//
//  ProductsViewController.swift
//  Goods store
//
//  Created by Pavel Akulenak on 26.06.21.
//

import RealmSwift
import UIKit

class ProductsViewController: UIViewController {
    var productCategory: ProductCategory?

    @IBOutlet weak var productsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        productsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "productsTableViewCell")
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.tableFooterView = UIView()
    }

    @objc private func onAddButton() {
        let alert = UIAlertController(title: "New product", message: "Еnter product name", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.textAlignment = .center
            alertTextField.keyboardType = .default
            alertTextField.font = UIFont(name: "Verdana", size: 17)
            alertTextField.placeholder = "Product name"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let name = alert.textFields?.first?.text else {
                assertionFailure()
                return
            }
            if !name.isEmpty {
                let product = Product()
                product.name = name
                do {
                    let realm = try Realm()
                    if !realm.objects(Product.self).contains(product) {
                        try realm.write {
                            self.productCategory?.product.append(product)
                        }
                    }
                } catch {
                    assertionFailure()
                }
                self.productsTableView.reloadData()
            }
        }
        let canselAction = UIAlertAction(title: "Cansel", style: .default, handler: nil)
        alert.addAction(addAction)
        alert.addAction(canselAction)
        present(alert, animated: true, completion: nil)
    }

    private func configureNavBar() {
        title = productCategory?.name
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddButton))
        navigationController?.navigationBar.tintColor = .label
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productCategory?.product.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "productsTableViewCell", for: indexPath)
        if let name = productCategory?.product.sorted(by: { $0.name < $1.name })[indexPath.row].name {
            cell.textLabel?.text = name
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = ProductViewController()
        viewController.product = productCategory?.product.sorted { $0.name < $1.name }[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}
