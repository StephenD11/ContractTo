//
//  DashboardViewModel.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import  Foundation

protocol DashboardViewModelProtocol {
    var screenTitle: String { get }
}

final class DashboardViewModel: DashboardViewModelProtocol{
    
    let screenTitle: String
    
    init(screenTitle: String = "Dashboard") {
        self.screenTitle = screenTitle
    }
}
