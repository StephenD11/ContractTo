//
//  ClientDetails.swift
//  ContractTo
//
//  Created by Stepan on 17.02.2026.
//

import UIKit

final class ClientDetailsViewController: BaseViewController {
    
    private let viewModel: ClientDetailsViewModelProtocol
    private let tableView = UITableView(frame: .zero, style: .plain).forAutoLayout()
    
    private let headerView = UIView().forAutoLayout()
    private let nameLabel = UILabel().forAutoLayout()
    private let emailLabel = UILabel().forAutoLayout()
    
    private let invoicesCountLabel = UILabel().forAutoLayout()
    private let totalAmountLabel = UILabel().forAutoLayout()
    
    var onInvoiceSelected: ((Invoice) -> Void)?
    
    
    init(viewModel: ClientDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.load()
        
        nameLabel.text = viewModel.client.name
        emailLabel.text = viewModel.client.email ?? "No email"
        
        invoicesCountLabel.font = DS.Typography.body()
        invoicesCountLabel.textAlignment = .center

        totalAmountLabel.font = DS.Typography.title()
        totalAmountLabel.textAlignment = .center
        
        invoicesCountLabel.text = "Invoices: \(viewModel.invoicesCount)"
        totalAmountLabel.text = "Total: \(formatCurrency(viewModel.totalAmount))"

        
        tableView.reloadData()
    }
    
    override func setupViews() {
        super.setupViews()
        
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "InvoiceCell")
        
        nameLabel.font = DS.Typography.title()
        nameLabel.textAlignment = .center
        
        
        
        emailLabel.font = DS.Typography.body()
        emailLabel.textColor = .secondaryLabel
        emailLabel.textAlignment = .center

        
        headerView.addSubview(nameLabel)
        headerView.addSubview(emailLabel)
        headerView.addSubview(invoicesCountLabel)
        headerView.addSubview(totalAmountLabel)
        view.addSubview(headerView)
        

        view.addSubview(tableView)
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()

        NSLayoutConstraint.activate([

            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            nameLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: DS.Spacing.l),
            nameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: DS.Spacing.s),
            emailLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            invoicesCountLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: DS.Spacing.m),
            invoicesCountLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            invoicesCountLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            totalAmountLabel.topAnchor.constraint(equalTo: invoicesCountLabel.bottomAnchor, constant: DS.Spacing.s),
            totalAmountLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            totalAmountLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            totalAmountLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -DS.Spacing.l),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func formatCurrency(_ value: Double) -> String {

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"

        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}


extension ClientDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel.invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "InvoiceCell")
        
        let invoice = viewModel.invoices[indexPath.row]
        
        cell.textLabel?.text = "Invoice #\(invoice.number)"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let invoice = viewModel.invoices[indexPath.row]

        onInvoiceSelected?(invoice)
    }
    
}

