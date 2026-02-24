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
    
    let client: Client
    private(set) var invoices: [Invoice] = []
    
    init(client: Client,
         invoiceRepository: InvoiceRepository,
         calculateTotalUseCase: CalculateInvoiceTotalUseCase) {

        self.client = client
        self.invoiceRepository = invoiceRepository
        self.calculateTotalUseCase = calculateTotalUseCase
    }
    
    func load() {
        
        do {
            let allInvoices = try invoiceRepository.fetchInvoices()
            
            invoices = allInvoices.filter { inv in return inv.clientId == client.id }
            
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


