//
//  Untitled.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import UIKit

final class InvoicesCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = InvoicesViewController()
        vc.title = "Invoices"

        navigationController.setViewControllers([vc], animated: false)
    }
}


