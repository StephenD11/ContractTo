//
//  RootTabBarController.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import UIKit


final class RootTabBarController : UITabBarController {
    
    init(tabs: [UIViewController]) {
           super.init(nibName: nil, bundle: nil)
           viewControllers = tabs
       }

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
}
