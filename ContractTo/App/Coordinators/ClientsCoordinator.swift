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
    private let invoiceRepository: InvoiceRepository


    init(navigationController: UINavigationController, clientRepository: ClientRepository, invoiceRepository: InvoiceRepository) {
        self.navigationController = navigationController
        self.clientRepository = clientRepository
        self.invoiceRepository = invoiceRepository
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
        
        let totalUseCase = DefaultCalculateInvoiceTotalUseCase()

        
        let viewModel = ClientDetailsViewModel(
            client: client,
            invoiceRepository: invoiceRepository,
            calculateTotalUseCase: totalUseCase
        )
        
        let vc = ClientDetailsViewController(viewModel: viewModel)
        
        vc.onInvoiceSelected = { [weak self] invoice in
            self?.showInvoiceDetails(invoice)
        }
        
        vc.title = client.name
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showInvoiceDetails(_ invoice: Invoice) {

        let detailsVC = InvoiceDetailsViewController(
            invoice: invoice,
            invoiceRepository: invoiceRepository
        )

        detailsVC.title = "Invoice #\(invoice.number)"

        navigationController.pushViewController(detailsVC, animated: true)
    }
    
}
