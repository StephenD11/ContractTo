//
//  ClientFormViewController.swift
//  ContractTo
//
//  Created by Stepan on 26.02.2026.
//


import UIKit

final class ClientFormViewController: BaseViewController {
    
    private let client: Client?
    
    private let nameField = UITextField().forAutoLayout()
    private let emailField = UITextField().forAutoLayout()
    
    var onSave: ((String, String?) -> Void)?
    
    init(client: Client?) {
        self.client = client
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.backgroundColor = .systemBackground
        
        nameField.placeholder = "ClientName"
        nameField.borderStyle = .roundedRect
        
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        
        view.addSubview(nameField)
        view.addSubview(emailField)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        
        nameField.text = client?.name
        emailField.text = client?.email
    }
    
    override func setupConstraints() {
        super.setupConstraints()

        NSLayoutConstraint.activate([

            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
            emailField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            emailField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor)
        ])
    }
    
    @objc private func saveTapped() {
        
        guard let name = nameField.text, !name.isEmpty else {return}
        
        onSave?(name, emailField.text)
    }
}
