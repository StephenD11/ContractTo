//
//  DashboardViewController.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import UIKit



final class DashboardViewController: BaseViewController {
        
    private let viewModel: any DashboardViewModelProtocol
    
    private let stackView = UIStackView().forAutoLayout()
    
    private let clientsLabel = UILabel().forAutoLayout()
    private let invoicesLabel = UILabel().forAutoLayout()
    private let unpaidLabel = UILabel().forAutoLayout()
    private let overdueLabel = UILabel().forAutoLayout()

    init(viewModel: DashboardViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    
    override func setupViews() {
        super.setupViews()
        
        stackView.axis = .vertical
        stackView.spacing = DS.Spacing.l
        
        [clientsLabel, invoicesLabel, unpaidLabel, overdueLabel]
            .forEach { label in
                label.font = DS.Typography.title()
                stackView.addArrangedSubview(label)
            }
        
        view.addSubview(stackView)
    }
    
    
    override func setupConstraints() {
        super.setupConstraints()

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func refresh() {
        viewModel.load()

        guard let stats = viewModel.stats else { return }

        clientsLabel.text = "Clients: \(stats.clientsCount)"
        invoicesLabel.text = "Invoices: \(stats.invoicesCount)"
        unpaidLabel.text = "Unpaid: \(stats.unpaidCount)"
        overdueLabel.text = "Overdue: \(stats.overdueCount)"
    }
}
