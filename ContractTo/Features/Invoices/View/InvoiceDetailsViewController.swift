//
//  InvoiceDetailsViewController.swift
//  ContractTo
//
//  Created by Stepan on 18.02.2026.
//

import UIKit

final class InvoiceDetailsViewController: BaseViewController {
    
    private let invoice: Invoice
    private let repository: InvoiceRepository
    
    private let viewModel: InvoiceDetailsViewModelProtocol
    private let tableView = UITableView(frame: .zero, style: .plain).forAutoLayout()
    
    private let totalLabel = UILabel().forAutoLayout()
    
    private let statusLabel = UILabel().forAutoLayout()
    private let markSentButton = UIButton(type: .system).forAutoLayout()
    private let markPaidButton = UIButton(type: .system).forAutoLayout()

    var onAddItemTapped: ((@escaping () -> Void) -> Void)?
    var onItemSelected: ((InvoiceItem, @escaping () -> Void) -> Void)?
    var onDeleteItem: ((InvoiceItem, @escaping () -> Void) -> Void)?

    init(invoice: Invoice, invoiceRepository: InvoiceRepository) {
        self.invoice = invoice
        self.repository = invoiceRepository
        
        let useCase = DefaultCalculateInvoiceTotalUseCase()
        
        self.viewModel = InvoiceDetailsViewModel(
            invoice: invoice,
            repository: invoiceRepository,
            calculateTotalUseCase: useCase
        )
        
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    private func refresh() {
        viewModel.loadItems()
        tableView.reloadData()
        updateHeader()
        updateStatusUI()           
    }
    
    private func updateHeader() {
        totalLabel.text = "Total: \(formatCurrency(viewModel.totalAmount))"
    }
    
    private func updateStatusUI() {
        statusLabel.text = "Status: \(invoice.computedStatus.rawValue.capitalized)"
    }
    
    override func setupViews() {
        super.setupViews()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemTapped))
        
        
        
        totalLabel.font = DS.Typography.title()
        totalLabel.textAlignment = .right
        
        statusLabel.font = DS.Typography.body()
        statusLabel.textAlignment = .center

        markSentButton.setTitle("Mark as Sent", for: .normal)
        markPaidButton.setTitle("Mark as Paid", for: .normal)

        markSentButton.addTarget(self,
                                 action: #selector(markSent),
                                 for: .touchUpInside)

        markPaidButton.addTarget(self,
                                 action: #selector(markPaid),
                                 for: .touchUpInside)

        view.addSubview(statusLabel)
        view.addSubview(markSentButton)
        view.addSubview(markPaidButton)
        
        view.addSubview(totalLabel)
        view.addSubview(tableView)
        

    }
    
    override func setupConstraints() {
        super.setupConstraints()

        NSLayoutConstraint.activate([

            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DS.Spacing.m),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DS.Spacing.l),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DS.Spacing.l),

            markSentButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: DS.Spacing.s),
            markSentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            markPaidButton.topAnchor.constraint(equalTo: markSentButton.bottomAnchor, constant: DS.Spacing.s),
            markPaidButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: markPaidButton.bottomAnchor, constant: DS.Spacing.m),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            totalLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: DS.Spacing.m),
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DS.Spacing.l),
            totalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DS.Spacing.l),
            totalLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -DS.Spacing.m)
        ])
    }
    
    @objc private func addItemTapped() {
        onAddItemTapped? { [weak self] in
            self?.refresh()
        }
    }
        
    @objc private func markSent() {
        updateStatus(.sent)
    }
    
    @objc private func markPaid() {
        updateStatus(.paid)
    }
    
    private func updateStatus(_ status: InvoiceStatus) {
        do {
            try repository.updateStatus(id: invoice.id, status: status)
            navigationController?.popViewController(animated: true)
        } catch {
            print("❌ Failed to update status")
        }
    }
    
}

extension InvoiceDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ItemCell")
        
        let item = viewModel.items[indexPath.row]
        
        cell.textLabel?.text = "\(item.title) — \(item.quantity)x \(item.unitPrice)"
        cell.detailTextLabel?.text = "Total: \(item.total)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.items[indexPath.row]
        
        
        onItemSelected?(item) { [weak self] in
            self?.refresh()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        guard editingStyle == .delete else { return }

        let item = viewModel.items[indexPath.row]

        onDeleteItem?(item) { [weak self] in
            self?.refresh()
        }
    }
}
