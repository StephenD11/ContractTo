//
//  InvoicesViewController.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import UIKit

final class InvoicesViewController: BaseViewController {

    private let titleLabel = UILabel().forAutoLayout()

    override func setupViews() {
        super.setupViews()

        titleLabel.text = "Invoices"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)

        view.addSubview(titleLabel)
    }

    override func setupConstraints() {
        super.setupConstraints()

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
