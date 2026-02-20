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
    var onInvoiceSelected: ((Invoice) -> Void)?
    
    init(viewModel: InvoicesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        tableView.rowHeight = UITableView.automaticDimension
        
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 80

        tableView.register(InvoiceTableViewCell.self, forCellReuseIdentifier: InvoiceTableViewCell.reuseId)

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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InvoiceTableViewCell.reuseId, for: indexPath) as? InvoiceTableViewCell else {
            return UITableViewCell()
        }
        
        
        let invoice = viewModel.invoices[indexPath.row]
        cell.configure(with: invoice)
        cell.accessoryType = .disclosureIndicator
    
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let invoice = viewModel.invoices[indexPath.row]
        onInvoiceSelected?(invoice)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            viewModel.deleteInvoice(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
