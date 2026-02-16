//
//  Untitled.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import UIKit

final class ClientsViewController: BaseViewController {
    
    private let viewModel : ClientsViewModelProtocol
    private let titleLabel = UILabel().forAutoLayout()
    
    init(viewModel: ClientsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadClients()
    }
    
    override func setupViews() {
        super.setupViews()

        titleLabel.text = "Clients count: \(viewModel.clients.count)"
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
