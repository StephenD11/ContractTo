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
    
    
    private let invoiceRepository: InvoiceRepository
    private let clientRepository: ClientRepository
    private let userProfileRepository: UserProfileRepository

    init(navigationController: UINavigationController, invoiceRepository: InvoiceRepository, clientRepository: ClientRepository, userProfileRepository: UserProfileRepository) {
        self.navigationController = navigationController
        
        self.invoiceRepository = invoiceRepository
        self.clientRepository = clientRepository
        self.userProfileRepository = userProfileRepository
    }

    func start() {
        let viewModel = InvoicesViewModel(repository: invoiceRepository)
        let vc = InvoicesViewController(viewModel: viewModel)
        vc.title = "Invoices"
        
        vc.onAddInvoiceTapped = { [weak self] in
            self?.showClientPicker()
        }
        
        vc.onInvoiceSelected = { [weak self] invoice in
            self?.showDetails(for: invoice)
        }

        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func showDetails(for invoice: Invoice) {
        
        let detailsVC = InvoiceDetailsViewController(invoice: invoice,
                                                         invoiceRepository: invoiceRepository)
        
        detailsVC.title = "Invoice #\(invoice.number)"

        navigationController.pushViewController(detailsVC, animated: true)
    }
    
    private func showClientPicker() {

        do {
            let clients = try clientRepository.fetchClients()

            let picker = ClientPickerViewController(clients: clients)
            picker.title = "Select Client"

            picker.onClientSelected = { [weak self] client in
                self?.createInvoice(for: client)
            }

            navigationController.pushViewController(picker, animated: true)

        } catch {
            print("❌ Failed to fetch clients")
        }
    }
    
    private func createInvoice(for client: Client) {

        do {
            
            let numberUseCase = DefaultGenerateInvoiceNumberUseCase(profileRepository: userProfileRepository)
            let nextNumber = try numberUseCase.execute()
            
            try invoiceRepository.createInvoice(for: client.id, number: nextNumber)


            navigationController.popViewController(animated: true)
            
//            // MARK: Лишний refresh() оставляю на всякий случай
//            if let invoicesVC = navigationController.viewControllers.first as? InvoicesViewController {
//                invoicesVC.refresh()
//            }

        } catch {
            print("❌ Failed to create invoice")
        }
    }
}


