//
//  UserProfileRepository.swift
//  ContractTo
//
//  Created by Stepan on 24.02.2026.
//

protocol UserProfileRepository {
    
    func fetchProfile() throws -> UserProfile?
    func createDefaultProfileIfNeeded() throws
    func incrementInvoiceNumber() throws -> Int
    
}

