//
//  ItemFormViewController.swift
//  ContractTo
//
//  Created by Stepan on 26.02.2026.
//

import UIKit

final class ItemFormViewController: BaseViewController {
    
    private let titleField = UITextField().forAutoLayout()
    private let quantityField = UITextField().forAutoLayout()
    private let priceField = UITextField().forAutoLayout()
    
    private let item: InvoiceItem?
    
    var onSave: ((InvoiceItem?, String, Double, Double) -> Void)?
    
    init(item: InvoiceItem?) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = .systemBackground

        titleField.placeholder = "Title"
        titleField.borderStyle = .roundedRect
        
        quantityField.placeholder = "Quantity"
        quantityField.borderStyle = .roundedRect
        quantityField.keyboardType = .decimalPad
        
        priceField.placeholder = "Unit price"
        priceField.borderStyle = .roundedRect
        priceField.keyboardType = .decimalPad
        
        if let item {
            titleField.text = item.title
            quantityField.text = "\(item.quantity)"
            priceField.text = "\(item.unitPrice)"
        }
        
        view.addSubview(titleField)
        view.addSubview(quantityField)
        view.addSubview(priceField)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
    }
    
    override func setupConstraints() {
           super.setupConstraints()

           NSLayoutConstraint.activate([

               titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
               titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
               titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

               quantityField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 16),
               quantityField.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
               quantityField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),

               priceField.topAnchor.constraint(equalTo: quantityField.bottomAnchor, constant: 16),
               priceField.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
               priceField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor)
           ])
       }
    
    private func parseDouble(from text: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal

        if let number = formatter.number(from: text) {
            return number.doubleValue
        }

        let normalized = text.replacingOccurrences(of: ",", with: ".")
        return Double(normalized)
    }

    private func showValidationError() {
        let alert = UIAlertController(
            title: "Invalid data",
            message: "Please enter title, quantity and price correctly.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func saveTapped() {

        guard let title = titleField.text, !title.isEmpty else {
            showValidationError()
            return
        }

        guard let quantityText = quantityField.text, !quantityText.isEmpty,
              let quantity = parseDouble(from: quantityText) else {
            showValidationError()
            return
        }

        guard let priceText = priceField.text, !priceText.isEmpty,
              let price = parseDouble(from: priceText) else {
            showValidationError()
            return
        }

        onSave?(item, title, quantity, price)
    }
    
}
