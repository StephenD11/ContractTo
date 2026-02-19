//
//  InvoiceRepository.swift
//  ContractTo
//
//  Created by Stepan on 17.02.2026.
//

import Foundation

protocol InvoiceRepository {
    
    func createInvoice(for clientId: UUID) throws
    
    func fetchInvoices() throws -> [Invoice]
    
    func deleteInvoice(id: UUID) throws
    
    func updateStatus(id:UUID, status: InvoiceStatus) throws
    
    func addItem(to invoiceId: UUID, title:String, quantity: Double, unitPrice: Double) throws
    
    func fetchItems(for invoiceId : UUID) throws -> [InvoiceItem]
    
}

