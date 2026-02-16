//
//  Coordinator.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] {get set}
    
    var navigationController: UINavigationController { get }
    
    func start()
 }
