//
//  InvoiceDetailsViewModel.swift
//  ContractTo
//
//  Created by Stepan on 19.02.2026.
//

import Foundation

protocol InvoiceDetailsViewModelProtocol {
    
    var items: [InvoiceItem] { get }
    
    func loadItems()
    func addItem(title:String, quantity: Double, unitPrice: Double)
}

final class InvoiceDetailsViewModel: InvoiceDetailsViewModelProtocol {
    
    private let invoice: Invoice
    private let repository: InvoiceRepository
    
    private(set) var items: [InvoiceItem] = []
    
    init(invoice: Invoice, repository: InvoiceRepository) {
        self.invoice = invoice
        self.repository = repository
    }
    
    func loadItems() {
        do {
            items = try repository.fetchItems(for: invoice.id)
        } catch {
            print("❌ Failed to fetch items")
        }
    }
    
    
    func addItem(title: String, quantity: Double, unitPrice: Double) {
        do {
            try repository.addItem(to: invoice.id, title: title, quantity: quantity, unitPrice: unitPrice)
            loadItems()
        } catch {
            print("❌ Failed to add item")
        }
    }
}
