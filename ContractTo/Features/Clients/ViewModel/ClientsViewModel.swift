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
    func addClient()
    func deleteClient(at index: Int)
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
    
    func addClient() {
        do {
            try repository.createClient(name: "Test Client \(clients.count + 1)", email: nil, address: nil, notes: nil )
            
            loadClients()
        } catch {
            print("❌ Failed to create client: \(error)")
        }
    }
    
    func deleteClient(at index: Int) {
        let client = clients[index]
        
        do {
            try repository.deleteClient(id: client.id)
            loadClients()
        } catch {
            print("❌ Failed to delete client: \(error)")
        }
    }

}
