//
//  CalculateDashboardStatsUseCase.swift
//  ContractTo
//
//  Created by Stepan on 19.02.2026.
//

import Foundation

protocol CalculateDashboardStatsUseCase {
    
    func execute() throws -> DashboardStats
}

final class DefaultCalculateDashboardStatsUseCase: CalculateDashboardStatsUseCase {
    
    private let clientRepository: ClientRepository
    private let invoiceRepository: InvoiceRepository
    
    init(clientRepository: ClientRepository, invoiceRepository: InvoiceRepository) {
        self.clientRepository = clientRepository
        self.invoiceRepository = invoiceRepository
    }
    
    func execute() throws -> DashboardStats {
        
        let clients = try clientRepository.fetchClients()
        let invoices = try invoiceRepository.fetchInvoices()
        
        let clientsCount = clients.count
        let invoicesCount = invoices.count
        
        let unpaidCount = invoices.filter { inv in inv.computedStatus != .paid }.count
        let overdueCount = invoices.filter { inv in inv.computedStatus == .overdue }.count
        
        return DashboardStats( clientsCount: clientsCount,
                               invoicesCount: invoicesCount,
                               unpaidCount: unpaidCount,
                               overdueCount: overdueCount)
    }
}
