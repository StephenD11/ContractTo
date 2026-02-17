//
//  InvoicesViewModel.swift
//  ContractTo
//
//  Created by Stepan on 17.02.2026.
//

import Foundation

protocol InvoicesViewModelProtocol {
    var invoices : [Invoice] { get }
    func loadInvoices()
}

final class InvoicesViewModel: InvoicesViewModelProtocol {
    
    private let repository: InvoiceRepository
    
    private(set) var invoices: [Invoice] = []
    
    init(repository: InvoiceRepository) {
        self.repository = repository
    }
    
    func loadInvoices() {
        do {
            invoices = try repository.fetchInvoices()
        } catch {
            print("❌ Failed to fetch invoices: \(error)")
        }
    }
    
}
