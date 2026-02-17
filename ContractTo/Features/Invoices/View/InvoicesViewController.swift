//
//  InvoicesViewController.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import UIKit

final class InvoicesViewController: BaseViewController {
    
    private let viewModel: InvoicesViewModelProtocol
    private let tableView = UITableView(frame: .zero, style: .plain).forAutoLayout()
    
    var onAddInvoiceTapped: (() -> Void)?
    
    init(viewModel: InvoicesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadInvoices()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    override func setupViews() {
        super.setupViews()
        
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)

        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "InvoiceCell")

    }

    override func setupConstraints() {
        super.setupConstraints()
        
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func addTapped() {
        onAddInvoiceTapped?()
    }
    
    func refresh() {
        viewModel.loadInvoices()
        tableView.reloadData()
    }
    
}

extension InvoicesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "InvoiceCell")
        
        let invoice = viewModel.invoices[indexPath.row]
        cell.textLabel?.text = "Invoice #\(invoice.number)"
        cell.accessoryType = .disclosureIndicator
        
        cell.detailTextLabel?.text = invoice.status.rawValue.capitalized
        
        switch invoice.status {
        case .draft:
            cell.detailTextLabel?.textColor = .secondaryLabel
        case .sent:
            cell.detailTextLabel?.textColor = .systemBlue
        case .paid:
            cell.detailTextLabel?.textColor = .systemGreen
        case .overdue:
            cell.detailTextLabel?.textColor = .systemRed
        }
        
        return cell
    }
}
