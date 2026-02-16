//
//  UIView+AutoLayout.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import UIKit

extension UIView {
    
    func forAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
