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
    private let userProfileRepository: UserProfileRepository


    init(navigationController: UINavigationController, clientRepository: ClientRepository, invoiceRepository: InvoiceRepository, userProfileRepository: UserProfileRepository) {
        self.navigationController = navigationController
        self.clientRepository = clientRepository
        self.invoiceRepository = invoiceRepository
        self.userProfileRepository = userProfileRepository
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
            clientRepository: clientRepository,
            invoiceRepository: invoiceRepository,
            calculateTotalUseCase: totalUseCase
        )
        
        let vc = ClientDetailsViewController(viewModel: viewModel)
        
        vc.onInvoiceSelected = { [weak self] invoice in
            self?.showInvoiceDetails(invoice)
        }
        
        vc.onCreateInvoiceTapped = { [weak self] client, completion in
            self?.createInvoice(for: client, completion: completion)
        }
        
        vc.onEditClientTapped = { [weak self] client in
            self?.showEditClient(client)
        }
        
        vc.onDeleteClientTapped = { [weak self] client in
            self?.confirmDelete(client)
        }
        
        vc.onDeleteInvoice = { [weak self] invoice, completion in
            self?.deleteInvoice(invoice, completion: completion)
        }
        
        vc.title = client.name
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showInvoiceDetails(_ invoice: Invoice) {

        let detailsVC = InvoiceDetailsViewController(
            invoice: invoice,
            invoiceRepository: invoiceRepository
        )
        
        detailsVC.onAddItemTapped = { [weak self] completion in
            self?.showAddItem(invoice: invoice, completion: completion)
        }

        detailsVC.onItemSelected = { [weak self] item, completion in
            self?.showEditItem(item: item, completion: completion)
        }

        detailsVC.onDeleteItem = { [weak self] item, completion in
            self?.deleteItem(item, completion: completion)
        }
        
        detailsVC.title = "Invoice #\(invoice.number)"

        navigationController.pushViewController(detailsVC, animated: true)
    }
    
    private func createInvoice(for client: Client, completion: @escaping () -> Void) {

        do {
            let numberUseCase = DefaultGenerateInvoiceNumberUseCase(
                profileRepository: userProfileRepository
            )

            let number = try numberUseCase.execute()

            try invoiceRepository.createInvoice(
                for: client.id,
                number: number
            )

            completion()

        } catch {
            print("❌ Failed to create invoice")
        }
    }
    
    private func showEditClient(_ client: Client) {
        
        let formVC = ClientFormViewController(client: client)
        formVC.title = "Edit Client"
        
        formVC.onSave = { [weak self] name, email in
            
            guard let self else { return }

            do {
                try self.clientRepository.updateClient(id: client.id, name: name, email: email)
                self.navigationController.popViewController(animated: true)
            } catch {
                print("❌ Failed to update client")
            }
            
        }
        
        navigationController.pushViewController(formVC, animated: true)
    }
    
    private func confirmDelete(_ client: Client) {

        let alert = UIAlertController(
            title: "Delete Client",
            message: "Are you sure you want to delete this client?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Delete",
                                      style: .destructive,
                                      handler: { [weak self] _ in
            self?.deleteClient(client)
        }))

        navigationController.present(alert, animated: true)
    }
    
    private func deleteClient(_ client: Client) {

        do {
            try clientRepository.deleteClient(id: client.id)

            navigationController.popViewController(animated: true)

        } catch {
            print("❌ Failed to delete client")
        }
    }
    
    private func deleteInvoice(_ invoice: Invoice,
                               completion: @escaping () -> Void) {

        do {
            try invoiceRepository.deleteInvoice(id: invoice.id)

            completion()

        } catch {
            print("❌ Failed to delete invoice")
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
