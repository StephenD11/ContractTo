//
//  GenerateInvoiceNumberUseCase.swift
//  ContractTo
//
//  Created by Stepan on 24.02.2026.
//

import Foundation

protocol GenerateInvoiceNumberUseCase {
    func execute() throws -> Int
}

final class DefaultGenerateInvoiceNumberUseCase: GenerateInvoiceNumberUseCase {
    
    private let  profileRepository: UserProfileRepository
    
    init(profileRepository: UserProfileRepository) {
        self.profileRepository = profileRepository
    }
    
    func execute() throws -> Int {
        
        try profileRepository.createDefaultProfileIfNeeded()

        let number = try profileRepository.incrementInvoiceNumber()

        return number
        
        
    }
}
