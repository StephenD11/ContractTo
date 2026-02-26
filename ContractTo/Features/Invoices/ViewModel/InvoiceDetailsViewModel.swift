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
    var totalAmount: Double { get }
    var subtotal: Double { get }
    
}

final class InvoiceDetailsViewModel: InvoiceDetailsViewModelProtocol {
    
    private let invoice: Invoice
    private let repository: InvoiceRepository
    
    private(set) var items: [InvoiceItem] = []
    
    var subtotal: Double { calculateTotalUseCase.execute(items: items) }
    var totalAmount: Double { calculateTotalUseCase.execute(items: items)}
    
    private let calculateTotalUseCase: CalculateInvoiceTotalUseCase
    
    
    
    init(invoice: Invoice, repository: InvoiceRepository, calculateTotalUseCase: CalculateInvoiceTotalUseCase) {
        self.invoice = invoice
        self.repository = repository
        self.calculateTotalUseCase = calculateTotalUseCase
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
