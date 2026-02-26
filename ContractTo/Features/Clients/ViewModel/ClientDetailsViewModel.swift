//
//  ClientDetailsViewModel.swift
//  ContractTo
//
//  Created by Stepan on 24.02.2026.
//

import Foundation

protocol ClientDetailsViewModelProtocol {
    
    var client: Client { get }
    var invoices: [Invoice] { get }
    
    var invoicesCount: Int { get }
    var totalAmount: Double { get }

    func load()
}

final class ClientDetailsViewModel:ClientDetailsViewModelProtocol {
    
    private let invoiceRepository: InvoiceRepository
    private let calculateTotalUseCase: CalculateInvoiceTotalUseCase
    private let clientRepository: ClientRepository
    
    private let clientId: UUID
    private(set) var client: Client
    private(set) var invoices: [Invoice] = []
    

    
    init(client: Client,
         clientRepository: ClientRepository,
         invoiceRepository: InvoiceRepository,
         calculateTotalUseCase: CalculateInvoiceTotalUseCase) {

        self.clientId = client.id
        self.client = client
        self.clientRepository = clientRepository
        self.invoiceRepository = invoiceRepository
        self.calculateTotalUseCase = calculateTotalUseCase
    }
    
    func load() {
        
        do {
            let clients = try clientRepository.fetchClients()
            if let updated = clients.first(where: { $0.id == clientId }) {
                client = updated
            }

            let allInvoices = try invoiceRepository.fetchInvoices()
            invoices = allInvoices.filter { $0.clientId == clientId }
            
        } catch {
            print("❌ Failed to load client invoices")
        }
    }
    
    
    var invoicesCount: Int {
        invoices.count
    }
    
    var totalAmount: Double {
        
        var total: Double = 0
        
        for invoice in  invoices {
            
            if let items = try? invoiceRepository.fetchItems(for: invoice.id) {
                total += calculateTotalUseCase.execute(items: items)
            }
        }
        
        return total
    }
}


