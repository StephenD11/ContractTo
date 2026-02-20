//
//  CalculateInvoiceTotalUseCase.swift
//  ContractTo
//
//  Created by Stepan on 20.02.2026.
//

import Foundation

protocol CalculateInvoiceTotalUseCase {
    func execute(items: [InvoiceItem]) -> Double
}

final class DefaultCalculateInvoiceTotalUseCase: CalculateInvoiceTotalUseCase {
    func execute(items: [InvoiceItem]) -> Double {
        items.reduce(0) { counting, add in return counting + add.total}
    }
}
