//
//  CoreDataUserProfileRepository.swift
//  ContractTo
//
//  Created by Stepan on 24.02.2026.
//

import CoreData

final class CoreDataUserProfileRepository: UserProfileRepository {
    
    private let context : NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchProfile() throws -> UserProfile? {
        
        let request: NSFetchRequest<CDUserProfile> = CDUserProfile.fetchRequest()
        guard let cdProfile = try context.fetch(request).first else {
            return nil
        }
        
        return UserProfile(
            id: cdProfile.id ?? UUID(),
            companyName: cdProfile.companyName ?? "",
            email: cdProfile.email ?? "",
            currencyCode: cdProfile.currencyCode ?? "USD",
            lastInvoiceNumber: Int(cdProfile.lastInvoiceNumber)
        )
    }
    
    func createDefaultProfileIfNeeded() throws {
        
        let request: NSFetchRequest<CDUserProfile> = CDUserProfile.fetchRequest()
        if try context.fetch(request).isEmpty {
            let profile = CDUserProfile(context: context)
            profile.id = UUID()
            profile.companyName = "My Company"
            profile.email = ""
            profile.currencyCode = "USD"
            profile.lastInvoiceNumber = 0
            
            try context.save()
        }
    }
    
    func incrementInvoiceNumber() throws -> Int {
        
        let request: NSFetchRequest<CDUserProfile> = CDUserProfile.fetchRequest()
        
        guard let profile = try context.fetch(request).first else {
            throw NSError(domain: "ProfileNotFound", code: 1)
        }
        
        profile.lastInvoiceNumber += 1
        
        try context.save()
        
        return Int(profile.lastInvoiceNumber)
    }
    
}
