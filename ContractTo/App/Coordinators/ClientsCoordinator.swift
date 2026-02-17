//
//  ClientsCoordinator.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import UIKit

final class ClientsCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    private let clientRepository: ClientRepository

    init(navigationController: UINavigationController, clientRepository: ClientRepository) {
        self.navigationController = navigationController
        self.clientRepository = clientRepository
    }

    func start() {
        let viewModel = ClientsViewModel(repository: clientRepository)
        let vc = ClientsViewController(viewModel: viewModel)
        vc.title = "Clients"
        
        vc.onClientSelected = { [weak self] client in
            self?.showDetails(for: client)
        }

        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func showDetails(for client: Client) {
        
        let detailsVC = ClientDetailsViewController(client: client)
        detailsVC.title = client.name
        
        navigationController.pushViewController(detailsVC, animated: true)
    }
}
