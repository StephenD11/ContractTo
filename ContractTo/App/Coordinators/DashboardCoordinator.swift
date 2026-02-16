//
//  DashboardCoordinator.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import UIKit

final class DashboardCoordinator : Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start () {
        let viewModel = DashboardViewModel()
        let vc = DashboardViewController(viewModel: viewModel)
        vc.title = "Dashboard"
        
        navigationController.setViewControllers([vc], animated: false)
    }
}
