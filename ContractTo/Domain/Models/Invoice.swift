//
//  Invoice.swift
//  ContractTo
//
//  Created by Stepan on 17.02.2026.
//

import Foundation

enum InvoiceStatus: String {
    case draft
    case sent
    case paid
    case overdue
}

struct Invoice {
    
    let id: UUID
    let number: Int
    let issueDate: Date
    let dueDate: Date
    let status: InvoiceStatus
    let clientId: UUID
    
    
    var computedStatus: InvoiceStatus {
        if status != .paid && dueDate < Date() {
            return .overdue
        }
        
        return status
    }
}




