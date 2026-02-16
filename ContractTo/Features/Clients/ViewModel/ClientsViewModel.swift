//
//  ClientsViewModel.swift
//  ContractTo
//
//  Created by Stepan on 16.02.2026.
//

import Foundation

protocol ClientsViewModelProtocol {
    var clients: [Client] { get }
    func loadClients()
}

final class ClientsViewModel : ClientsViewModelProtocol {
    
    private let repository : ClientRepository
    
    private(set) var clients : [Client] = []
    
    init(repository: ClientRepository) {
        self.repository = repository
    }
    
    func loadClients() {
        do {
            clients = try repository.fetchClients()
        } catch {
            print("❌ Failed to fetch clients: \(error)")
        }
    }
}
