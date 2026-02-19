//
//  InvoiceTableViewCell.swift
//  ContractTo
//
//  Created by Stepan on 18.02.2026.
//

import UIKit

final class InvoiceTableViewCell : UITableViewCell {
    
    static let reuseId = "InvoiceTableViewCell"
    
    
    private let numberLabel = UILabel().forAutoLayout()
    private let statusLabel = UILabel().forAutoLayout()
    private let dueDateLabel = UILabel().forAutoLayout()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier )
        
        setupViews()
        setupConstraints()	
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        numberLabel.font = DS.Typography.body()
        numberLabel.textColor = DS.Colors.textPrimary
        
        statusLabel.font = DS.Typography.body()
        
        dueDateLabel.font = DS.Typography.caption()
        dueDateLabel.textColor = DS.Colors.textSecondary
        
        contentView.addSubview(numberLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(dueDateLabel)
        
    }
    
    private func setupConstraints() {

        NSLayoutConstraint.activate([

            numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Spacing.l),
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),

            statusLabel.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),

            dueDateLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: DS.Spacing.s),
            dueDateLabel.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor),
            dueDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DS.Spacing.l)
        ])
    }
    
    func configure(with invoice: Invoice) {
        
        numberLabel.text = "Invoice #\(invoice.number)"
        
        let status = invoice.computedStatus
        statusLabel.text = status.rawValue.capitalized
        
        switch status {
        case .draft:
            statusLabel.textColor = .secondaryLabel
        case .sent:
            statusLabel.textColor = .systemBlue
        case .paid:
            statusLabel.textColor = .systemGreen
        case .overdue:
            statusLabel.textColor = .systemRed
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        dueDateLabel.text = "Due: \(formatter.string(from: invoice.dueDate))"
    }
    
}
