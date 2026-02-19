//
//  BaseViewController.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        
        setupViews()
        
        setupConstraints()
        
    }
    
    func setupAppearance() {
        view.backgroundColor = DS.Colors.background
        
        // MARK: Большие заголовки
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupViews() {
        
    }
    
    func setupConstraints() {
        
    }
}
