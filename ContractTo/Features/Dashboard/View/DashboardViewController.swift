//
//  DashboardViewController.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import UIKit



final class DashboardViewController: BaseViewController {
        
    private let viewModel: any DashboardViewModelProtocol
    private let titleLabel = UILabel().forAutoLayout()

    init(viewModel: DashboardViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = viewModel.screenTitle
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
