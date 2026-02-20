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
    
    private let clientRepository: ClientRepository
    private let invoiceRepository: InvoiceRepository
    
    init(navigationController: UINavigationController, clientRepository: ClientRepository, invoiceRepository: InvoiceRepository) {
        self.navigationController = navigationController
        self.clientRepository = clientRepository
        self.invoiceRepository = invoiceRepository
    }
    
    func start () {
        
        let calculateTotalUseCase = DefaultCalculateInvoiceTotalUseCase()

        let useCase = DefaultCalculateDashboardStatsUseCase(clientRepository: clientRepository, invoiceRepository: invoiceRepository,calculateTotalUseCase: calculateTotalUseCase)
        
        let viewModel = DashboardViewModel(useCase: useCase)
        
        let vc = DashboardViewController(viewModel: viewModel)
        vc.title = "Dashboard"
        
        navigationController.setViewControllers([vc], animated: false)
    }
}
