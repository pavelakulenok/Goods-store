//
//  CategoriesViewController.swift
//  Goods store
//
//  Created by Pavel Akulenak on 26.06.21.
//

import RealmSwift
import UIKit

class CategoriesViewController: UIViewController {
    private var categories: Results<ProductCategory>?
    @IBOutlet weak var categoriesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        categoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoriesTableViewCell")
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.tableFooterView = UIView()
        do {
            let realm = try Realm()
            categories = realm.objects(ProductCategory.self)
        } catch {
            assertionFailure()
        }
    }

    @objc private func onAddCategoryButton() {
        let alert = UIAlertController(title: "New category", message: "Еnter category name", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.textAlignment = .center
            alertTextField.keyboardType = .default
            alertTextField.font = UIFont(name: "Verdana", size: 17)
            alertTextField.placeholder = "Category name"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let name = alert.textFields?.first?.text else {
                assertionFailure()
                return
            }
            if !name.isEmpty {
                let category = ProductCategory()
                category.name = name
                do {
                    let realm = try Realm()
                    if !realm.objects(ProductCategory.self).contains(category) {
                        try realm.write {
                            realm.add(category)
                        }
                        self.categories = realm.objects(ProductCategory.self)
                    }
                } catch {
                    assertionFailure()
                }
                self.categoriesTableView.reloadData()
            }
        }
        let canselAction = UIAlertAction(title: "Cansel", style: .default, handler: nil)
        alert.addAction(addAction)
        alert.addAction(canselAction)
        present(alert, animated: true, completion: nil)
    }

    private func configureNavBar() {
        title = "Categories"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddCategoryButton))
        navigationController?.navigationBar.tintColor = .label
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriesTableView.dequeueReusableCell(withIdentifier: "categoriesTableViewCell", for: indexPath)
        let name = categories?.sorted { $0.name < $1.name }[indexPath.row].name
            cell.textLabel?.text = name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = ProductsViewController.instantiate()
        viewController.productCategory = categories?.sorted { $0.name < $1.name }[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}
