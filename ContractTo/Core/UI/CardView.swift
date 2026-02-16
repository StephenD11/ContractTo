//
//  CardView.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//

import UIKit

final class CardVie: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = DS.Colors.secondaryBackground
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
    }
}
