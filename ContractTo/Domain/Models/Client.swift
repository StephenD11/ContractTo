//
//  Client.swift
//  ContractTo
//
//  Created by Stepan on 16.02.2026.
//

import Foundation

struct Client {
    
    let id: UUID
    let name: String
    let email: String?
    let address: String?
    let notes: String?
    let createdAt: Date
}
