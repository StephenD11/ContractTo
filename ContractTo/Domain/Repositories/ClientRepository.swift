//
//  ClientRepository.swift
//  ContractTo
//
//  Created by Stepan on 16.02.2026.
//

import Foundation
    
protocol ClientRepository {
    
    func createClient(name: String, email: String?, address: String?, notes: String?) throws
    
    func fetchClients() throws -> [Client]
    
    func deleteClient(id: UUID) throws
    
    func updateClient(id: UUID, name: String, email: String?) throws
}
