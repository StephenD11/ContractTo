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
    
    private let editButton = UIButton(type: .system)
    
    
    
    var onInvoiceSelected: ((Invoice) -> Void)?
    var onCreateInvoiceTapped: ((Client, @escaping () -> Void) -> Void)?
    var onEditClientTapped: ((Client) -> Void)?
    var onClientUpdated: (() -> Void)?
    var onDeleteClientTapped: ((Client) -> Void)?
    var onDeleteInvoice: ((Invoice, @escaping () -> Void) -> Void)?
    
    
    private let createInvoiceButton = UIButton(type: .system).forAutoLayout()
    
    
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
        title = viewModel.client.name
        
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
        headerView.addSubview(createInvoiceButton)
        
        createInvoiceButton.setTitle("Create Invoice", for: .normal)
        createInvoiceButton.titleLabel?.font = DS.Typography.title()
        createInvoiceButton.addTarget(self, action: #selector(createInvoiceTapped), for: .touchUpInside)
        
        editButton.setTitle("Edit", for: .normal)
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
        
        let deleteItem = UIBarButtonItem(
            title: "Delete",
            style: .plain,
            target: self,
            action: #selector(deleteTapped)
        )
        
        navigationItem.rightBarButtonItems = [ UIBarButtonItem(customView: editButton), deleteItem]
        
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
            
            createInvoiceButton.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: DS.Spacing.m),
            createInvoiceButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            createInvoiceButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -DS.Spacing.l),
            
            
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    

    
    @objc private func createInvoiceTapped() {
        onCreateInvoiceTapped?(viewModel.client, { [weak self] in
            self?.reloadScreen()
        })
    }
    
    @objc private func editTapped() {
        onEditClientTapped?(viewModel.client)
    }
    
    @objc private func deleteTapped() {
        onDeleteClientTapped?(viewModel.client)
    }
    
    private func reloadScreen() {
        viewModel.load()
        tableView.reloadData()

        invoicesCountLabel.text = "Invoices: \(viewModel.invoicesCount)"
        totalAmountLabel.text = "Total: \(formatCurrency(viewModel.totalAmount))"
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
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let invoice = viewModel.invoices[indexPath.row]

        onInvoiceSelected?(invoice)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        guard editingStyle == .delete else { return }

        let invoice = viewModel.invoices[indexPath.row]

        onDeleteInvoice?(invoice) { [weak self] in
            self?.reloadScreen()
        }
    }
}

