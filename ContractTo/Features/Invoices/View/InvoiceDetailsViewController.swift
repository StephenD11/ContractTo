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
    
    private let markSentButton = UIButton(type: .system).forAutoLayout()
    private let markPaidButton = UIButton(type: .system).forAutoLayout()
    
    private let statusLabel = UILabel().forAutoLayout()

    init(invoice: Invoice, invoiceRepository: InvoiceRepository) {
        self.invoice = invoice
        self.repository = invoiceRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        
        statusLabel.font = DS.Typography.title()
        statusLabel.text = "Status \(invoice.status.rawValue.capitalized)"
        
        markSentButton.setTitle("Mark as Sent", for: .normal)
        markPaidButton.setTitle("Mark as Paid", for: .normal)
        
        markSentButton.addTarget(self, action: #selector(markSent), for: .touchUpInside)
        markPaidButton.addTarget(self, action: #selector(markPaid), for: .touchUpInside)
        
        view.addSubview(statusLabel)
        view.addSubview(markSentButton)
        view.addSubview(markPaidButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            markSentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            markSentButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: DS.Spacing.l),

            markPaidButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            markPaidButton.topAnchor.constraint(equalTo: markSentButton.bottomAnchor, constant: DS.Spacing.m)
        ])
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
