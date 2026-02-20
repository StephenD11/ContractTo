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
    private let calculateTotalUseCase: CalculateInvoiceTotalUseCase
    
    
    
    init(clientRepository: ClientRepository, invoiceRepository: InvoiceRepository, calculateTotalUseCase: CalculateInvoiceTotalUseCase) {
        
        self.clientRepository = clientRepository
        self.invoiceRepository = invoiceRepository
        self.calculateTotalUseCase = calculateTotalUseCase

    }
    
    func execute() throws -> DashboardStats {
        
        let clients = try clientRepository.fetchClients()
        let invoices = try invoiceRepository.fetchInvoices()
        
        var totalRevenue: Double = 0
        var outstandingAmount: Double = 0
        var overdueAmount: Double = 0
        
        for invoice in invoices {
            
            let items = try invoiceRepository.fetchItems(for: invoice.id)
            let total = calculateTotalUseCase.execute(items: items)
            
            switch invoice.computedStatus {
            case .paid:
                totalRevenue += total
            case .overdue:
                overdueAmount += total
            default:
                outstandingAmount += total
            }
        }
        
        return DashboardStats(
            clientsCount: clients.count,
            invoicesCount: invoices.count,
            unpaidCount: invoices.filter { $0.computedStatus != .paid }.count,
            overdueCount: invoices.filter { $0.computedStatus == .overdue }.count,
            totalRevenue: totalRevenue,
            outstandingAmount: outstandingAmount,
            overdueAmount: overdueAmount
        )
    }
}
