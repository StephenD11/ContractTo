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

    init(navigationController: UINavigationController, invoiceRepository: InvoiceRepository, clientRepository: ClientRepository) {
        self.navigationController = navigationController
        
        self.invoiceRepository = invoiceRepository
        self.clientRepository = clientRepository
    }

    func start() {
        let viewModel = InvoicesViewModel(repository: invoiceRepository)
        let vc = InvoicesViewController(viewModel: viewModel)
        vc.title = "Invoices"
        
        vc.onAddInvoiceTapped = { [weak self] in
            self?.showClientPicker()
        }

        navigationController.setViewControllers([vc], animated: false)
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
            try invoiceRepository.createInvoice(for: client.id)

            navigationController.popViewController(animated: true)

            if let invoicesVC = navigationController.viewControllers.first as? InvoicesViewController {
                invoicesVC.refresh()
            }

        } catch {
            print("❌ Failed to create invoice")
        }
    }
}


