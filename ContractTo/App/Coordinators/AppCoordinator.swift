//
//  AppCoordinator.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController

    
    private let window: UIWindow
    
    private let coreDataStack: CoreDataStack
    private let clientRepository: ClientRepository
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.coreDataStack = CoreDataStack(modelName: "ContractModel")
        
        self.clientRepository = CoreDataClientRepository(
            context: coreDataStack.viewContext
        )
    }
    
    
    
    func start() {
        
        // NavigationController's
        
        let dashboardNav = UINavigationController()
        dashboardNav.navigationBar.prefersLargeTitles = true
        dashboardNav.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "house"), tag: 0)
        
        let clientsNav = UINavigationController()
        clientsNav.navigationBar.prefersLargeTitles = true
        clientsNav.tabBarItem = UITabBarItem(title: "Clients",image: UIImage(systemName: "person.2"),tag: 1)

        let invoicesNav = UINavigationController()
        invoicesNav.navigationBar.prefersLargeTitles = true
        invoicesNav.tabBarItem = UITabBarItem(title: "Invoices",image: UIImage(systemName: "doc.text"),tag: 2)

        let settingsNav = UINavigationController()
        settingsNav.navigationBar.prefersLargeTitles = true
        settingsNav.tabBarItem = UITabBarItem(title: "Settings",image: UIImage(systemName: "gearshape"),tag: 3)
        
        // Координаторы вкладок
        
        let dashboardCoordinator = DashboardCoordinator(navigationController: dashboardNav)
        let clientsCoordinator = ClientsCoordinator(navigationController: clientsNav, clientRepository: clientRepository)
        let invoicesCoordinator = InvoicesCoordinator(navigationController: invoicesNav)
        let settingsCoordinator = SettingsCoordinator(navigationController: settingsNav)
        
        childCoordinators = [ dashboardCoordinator, clientsCoordinator, invoicesCoordinator,settingsCoordinator ]
        
        dashboardCoordinator.start()
        clientsCoordinator.start()
        invoicesCoordinator.start()
        settingsCoordinator.start()
        
        let tabBar = RootTabBarController( tabs: [ dashboardNav, clientsNav, invoicesNav, settingsNav])
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }
    
}
