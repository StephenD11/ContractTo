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
        
        detailsVC.onAddItemTapped = { [weak self] completion in
            self?.showAddItem(invoice: invoice, completion: completion)
        }
        
        detailsVC.onItemSelected = { [weak self] item, completion in
            self?.showEditItem(item: item, completion: completion)
        }
        
        detailsVC.onDeleteItem = { [weak self] item, completion in
            self?.deleteItem(item, completion: completion)
        }

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
            

        } catch {
            print("❌ Failed to create invoice")
        }
    }
    
    private func showAddItem(invoice: Invoice,
                             completion: @escaping () -> Void) {

        let formVC = ItemFormViewController(item: nil)
        formVC.title = "New Item"

        formVC.onSave = { [weak self] _, title, quantity, price in

            guard let self else { return }

            do {
                try self.invoiceRepository.addItem(
                    to: invoice.id,
                    title: title,
                    quantity: quantity,
                    unitPrice: price
                )

                self.navigationController.popViewController(animated: true)

                completion()

            } catch {
                print("❌ Failed to add item")
            }
        }

        navigationController.pushViewController(formVC, animated: true)
    }
    
    private func showEditItem(item: InvoiceItem,
                              completion: @escaping () -> Void) {

        let formVC = ItemFormViewController(item: item)
        formVC.title = "Edit Item"

        formVC.onSave = { [weak self] item, title, quantity, price in

            guard let self, let item else { return }

            do {
                try self.invoiceRepository.updateItem(
                    id: item.id,
                    title: title,
                    quantity: quantity,
                    unitPrice: price
                )

                self.navigationController.popViewController(animated: true)

                completion()

            } catch {
                print("❌ Failed to update item")
            }
        }

        navigationController.pushViewController(formVC, animated: true)
    }
    
    private func deleteItem(_ item: InvoiceItem,
                            completion: @escaping () -> Void) {

        do {
            try invoiceRepository.deleteItem(id: item.id)

            completion()

        } catch {
            print("❌ Failed to delete item")
        }
    }
}


