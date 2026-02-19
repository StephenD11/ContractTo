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
    
}

