//
//  CoreDataClientRepository.swift
//  ContractTo
//
//  Created by Stepan on 16.02.2026.
//

import CoreData

final class CoreDataClientRepository : ClientRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    func createClient(name: String, email: String?, address: String?, notes: String?) throws {
        
        let cdClient = CDClient(context: context)
        
        cdClient.id = UUID()
        cdClient.name = name
        cdClient.email = email
        cdClient.address = address
        cdClient.notes = notes
        cdClient.createdAt = Date()
        
        try context.save()
    }
    
    func fetchClients() throws -> [Client] {
        
        let request: NSFetchRequest<CDClient> = CDClient.fetchRequest()
        
        let results = try context.fetch(request)
        
        return results.map { cd in
            Client(id: cd.id ?? UUID(), name: cd.name ?? "", email: cd.email, address: cd.address, notes: cd.notes, createdAt: cd.createdAt ?? Date()
               )
        }
    }
    
    
    func deleteClient(id: UUID) throws {
        let request: NSFetchRequest<CDClient> = CDClient.fetchRequest()
        
        let results = try context.fetch(request)
        
        if let object = results.first {
            context.delete(object)
            try context.save()
        }
    }
}
