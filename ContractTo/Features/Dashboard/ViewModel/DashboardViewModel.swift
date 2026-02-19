//
//  DashboardViewModel.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import  Foundation

protocol DashboardViewModelProtocol {
    var stats: DashboardStats? { get }
    func load()
}

final class DashboardViewModel: DashboardViewModelProtocol{
    
    private let useCase: CalculateDashboardStatsUseCase
    private(set) var stats: DashboardStats?

    init(useCase: CalculateDashboardStatsUseCase) {
        self.useCase = useCase
    }
    

    func load() {
        do {
            stats = try useCase.execute()
        } catch {
            print("❌ Dashboard load error: \(error)")
        }
    }
}
