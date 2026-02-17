//
//  ClientDetails.swift
//  ContractTo
//
//  Created by Stepan on 17.02.2026.
//

import UIKit

final class ClientDetailsViewController: BaseViewController {
    
    private let client: Client
    private let nameLabel = UILabel().forAutoLayout()
    
    init(client: Client) {
        self.client = client
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        
        nameLabel.font = DS.Typography.title()
        nameLabel.text = client.name
        
        view.addSubview(nameLabel)
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
