//
//  CurrencyFormatter.swift
//  ContractTo
//
//  Created by Stepan on 26.02.2026.
//

import Foundation

func formatCurrency(_ value: Double) -> String {

    let formatter = NumberFormatter()
    formatter.numberStyle = .currencyISOCode
    formatter.locale = Locale.current

    return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
}
