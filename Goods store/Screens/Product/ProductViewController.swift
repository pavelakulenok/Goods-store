//
//  ProductViewController.swift
//  Goods store
//
//  Created by Pavel Akulenak on 26.06.21.
//

import RealmSwift
import UIKit

class ProductViewController: UIViewController {
    var product: Product?
    var transactionsArray = [ProductTransaction]()
    private lazy var dateFormatter = DateFormatter()
    private var scrollView = UIScrollView()
    private var productView = UIView()
    private var productNameLabel = UILabel()
    private var quantityOfProductInStockLabel = UILabel()
    private var priceTextField = UITextField()
    private var quantityTextField = UITextField()
    private var sellButton = UIButton()
    private var buyButton = UIButton()
    private var productTransactionsTableView = UITableView()
    private var viewForAddShadowTableView = UIView()

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        self.view = view
        view.addSubview(scrollView)
        scrollView.addSubview(productView)
        productView.addSubview(productNameLabel)
        productView.addSubview(quantityOfProductInStockLabel)
        productView.addSubview(priceTextField)
        productView.addSubview(quantityTextField)
        productView.addSubview(buyButton)
        productView.addSubview(sellButton)
        scrollView.addSubview(viewForAddShadowTableView)
        viewForAddShadowTableView.addSubview(productTransactionsTableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsUI()
        setupLabelsUI()
        setupButtonsUI()
        setupTextFieldsUI()
        productTransactionsTableView.delegate = self
        productTransactionsTableView.dataSource = self
        quantityTextField.delegate = self
        priceTextField.delegate = self
        productTransactionsTableView.register(UINib(nibName: "ProductTransactionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        productTransactionsTableView.tableFooterView = UIView()
        buyButton.addTarget(self, action: #selector(onBuyButton), for: .touchUpInside)
        sellButton.addTarget(self, action: #selector(onSellButton), for: .touchUpInside)
        if let name = product?.name {
            productNameLabel.text = name
        }
        if let quantity = product?.quantity {
            quantityOfProductInStockLabel.text = "In stock \(quantity) pcs"
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        if let array = product?.productTransactions {
            transactionsArray = array.sorted { $0.date > $1.date }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: productView.frame.width, height: productView.frame.height + productTransactionsTableView.frame.height + 60)
        productView.frame = CGRect(x: 20, y: 20, width: scrollView.frame.width - 40, height: 300)
        productNameLabel.frame = CGRect(x: 20, y: 20, width: productView.frame.width - 40, height: 60)
        quantityOfProductInStockLabel.frame = CGRect(x: 20, y: productNameLabel.frame.maxY + 5, width: productView.frame.width - 40, height: 30)
        priceTextField.frame = CGRect(x: 50, y: quantityOfProductInStockLabel.frame.maxY + 20, width: productView.frame.width - 100, height: 30)
        quantityTextField.frame = CGRect(x: 50, y: priceTextField.frame.maxY + 5, width: productView.frame.width - 100, height: 30)
        buyButton.frame = CGRect(x: 50, y: quantityTextField.frame.maxY + 30, width: 70, height: 50)
        sellButton.frame = CGRect(x: productView.frame.width - 120, y: quantityTextField.frame.maxY + 30, width: 70, height: 50)
        viewForAddShadowTableView.frame = CGRect(x: 20, y: productView.frame.maxY + 20, width: scrollView.frame.width - 40, height: 400)
        productTransactionsTableView.frame = viewForAddShadowTableView.bounds
    }

    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    @objc private func onBuyButton() {
        guard let priseString = priceTextField.text, let quantityString = quantityTextField.text, let name = product?.name else {
            assertionFailure()
            return
        }
        if !priseString.isEmpty && !quantityString.isEmpty {
            if let prise = Double(priseString), let quantity = Int(quantityString) {
                let transaction = ProductTransaction()
                transaction.name = name
                transaction.price = prise
                transaction.quantity = quantity
                transaction.type = "purchase"
                dateFormatter.dateFormat = "dd.MM.YY HH:mm"
                let date = "\(dateFormatter.string(from: Date()))"
                transaction.date = date
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(transaction)
                        product?.productTransactions.append(transaction)
                        product?.quantity += quantity
                    }
                } catch {
                    assertionFailure()
                }
                if let array = product?.productTransactions {
                    transactionsArray = array.sorted { $0.date > $1.date }
                }
                productTransactionsTableView.reloadData()
                priceTextField.text = nil
                quantityTextField.text = nil
                if let quantity = product?.quantity {
                    quantityOfProductInStockLabel.text = "In stock \(quantity) pcs"
                }
            } else {
                showAlertWithOneButton(title: "Error", message: "Enter correct price and quantity values", actionTitle: "Ok", actionStyle: .default, handler: nil)
            }
        } else {
            showAlertWithOneButton(title: "Error", message: "Enter prise and quantity values", actionTitle: "Ok", actionStyle: .default, handler: nil)
        }
    }

    @objc private func onSellButton() {
        guard let priseString = priceTextField.text, let quantityString = quantityTextField.text, let name = product?.name else {
            assertionFailure()
            return
        }
        if !priseString.isEmpty && !quantityString.isEmpty {
            if let prise = Double(priseString), let quantity = Int(quantityString), let productQuantity = product?.quantity {
                if productQuantity >= quantity {
                    let transaction = ProductTransaction()
                    transaction.name = name
                    transaction.price = prise
                    transaction.quantity = quantity
                    transaction.type = "sale"
                    dateFormatter.dateFormat = "dd.MM.YY HH:mm"
                    let date = "\(dateFormatter.string(from: Date()))"
                    transaction.date = date
                    do {
                        let realm = try Realm()
                        try realm.write {
                            realm.add(transaction)
                            product?.productTransactions.append(transaction)
                            product?.quantity -= quantity
                        }
                    } catch {
                        assertionFailure()
                    }
                    if let array = product?.productTransactions {
                        transactionsArray = array.sorted { $0.date > $1.date }
                    }
                    productTransactionsTableView.reloadData()
                    priceTextField.text = nil
                    quantityTextField.text = nil
                    if let quantity = product?.quantity {
                        quantityOfProductInStockLabel.text = "In stock \(quantity) pcs"
                    }
                } else {
                    showAlertWithOneButton(title: "Error", message: "In total in stock \(productQuantity) pieces", actionTitle: "Ok", actionStyle: .default, handler: nil)
                }
            } else {
                showAlertWithOneButton(title: "Error", message: "Enter correct price and quantity values", actionTitle: "Ok", actionStyle: .default, handler: nil)
            }
        } else {
            showAlertWithOneButton(title: "Error", message: "Enter prise and quantity values", actionTitle: "Ok", actionStyle: .default, handler: nil)
        }
    }

    private func setupViewsUI() {
        view.backgroundColor = .systemBackground
        productTransactionsTableView.applyCornerRadius(25)
        productView.applyCornerRadius(25)
        viewForAddShadowTableView.applyCornerRadius(25)
        viewForAddShadowTableView.addShadow(color: .label, opacity: 1, offSet: .zero, radius: 10)
        viewForAddShadowTableView.backgroundColor = .systemBackground
        productView.addShadow(color: .label, opacity: 1, offSet: .zero, radius: 10)
        productView.backgroundColor = .white
    }

    private func setupLabelsUI() {
        productNameLabel.backgroundColor = .systemGray5
        productNameLabel.applyCornerRadius(15)
        productNameLabel.font = UIFont(name: "Verdana", size: 17)
        productNameLabel.textAlignment = .center
        productNameLabel.numberOfLines = 0
        quantityOfProductInStockLabel.backgroundColor = .systemGray5
        quantityOfProductInStockLabel.applyCornerRadius(10)
        quantityOfProductInStockLabel.font = UIFont(name: "Verdana", size: 17)
        quantityOfProductInStockLabel.textAlignment = .center
    }

    private func setupTextFieldsUI() {
        priceTextField.applyCornerRadius(10)
        priceTextField.backgroundColor = .systemGray5
        priceTextField.textAlignment = .center
        priceTextField.keyboardType = .numbersAndPunctuation
        priceTextField.font = UIFont(name: "Verdana", size: 17)
        priceTextField.placeholder = "price"
        quantityTextField.applyCornerRadius(10)
        quantityTextField.backgroundColor = .systemGray5
        quantityTextField.textAlignment = .center
        quantityTextField.keyboardType = .numbersAndPunctuation
        quantityTextField.font = UIFont(name: "Verdana", size: 17)
        quantityTextField.placeholder = "quantity of product"
    }

    private func setupButtonsUI() {
        sellButton.applyCornerRadius(15)
        sellButton.addShadow(color: .gray, opacity: 1, offSet: .zero, radius: 10)
        sellButton.setTitle("Sell", for: .normal)
        sellButton.backgroundColor = .red
        sellButton.setTitleColor(.label, for: .normal)
        sellButton.titleLabel?.font = UIFont(name: "Verdana Bold", size: 17)
        buyButton.applyCornerRadius(15)
        buyButton.addShadow(color: .gray, opacity: 1, offSet: .zero, radius: 10)
        buyButton.backgroundColor = .green
        buyButton.setTitle("Buy", for: .normal)
        buyButton.setTitleColor(.label, for: .normal)
        buyButton.titleLabel?.font = UIFont(name: "Verdana Bold", size: 17)
    }
}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsArray.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("ProductTransactionTableViewCell", owner: self, options: nil)?.first as? ProductTransactionTableViewCell
        headerView?.dateLabel.text = "Date"
        headerView?.quantityLabel.text = "Quantity"
        headerView?.priceLabel.text = "Prise"
        headerView?.backgroundColor = .systemGray5
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = productTransactionsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProductTransactionTableViewCell else {
            return UITableViewCell()
        }
        cell.dateLabel.text = transactionsArray[indexPath.row].date
        cell.quantityLabel.text = "\(transactionsArray[indexPath.row].quantity)"
        cell.priceLabel.text = "\(transactionsArray[indexPath.row].price)"
        if transactionsArray[indexPath.row].type == "purchase" {
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .red
        }
        return cell
    }
}

extension ProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
