//
//  InvoiceItem.swift
//  ContractTo
//
//  Created by Stepan on 19.02.2026.
//

import Foundation

struct InvoiceItem {
    
    let id: UUID
    let title: String
    let quantity: Double
    let unitPrice: Double
    
    var total: Double {
        quantity * unitPrice
    }
}
