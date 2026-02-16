//
//  DesignSystem.swift
//  ContractTo
//
//  Created by Stepan on 13.02.2026.
//


import UIKit


enum DS {
    enum Spacing {
        static let xs: CGFloat = 4
        static let s: CGFloat  = 8
        static let m: CGFloat  = 12
        static let l: CGFloat  = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }
}

extension DS {
    
    enum Typography {
        static func title() -> UIFont {
            UIFont.preferredFont(forTextStyle: .title1)
        }
        
        static func body() -> UIFont {
                    UIFont.preferredFont(forTextStyle: .body)
        }

        static func caption() -> UIFont {
            UIFont.preferredFont(forTextStyle: .caption1)
        }
    }
}

extension DS {

    enum Colors {

        static var background: UIColor { .systemBackground }
        static var secondaryBackground: UIColor { .secondarySystemBackground }

        static var textPrimary: UIColor { .label }
        static var textSecondary: UIColor { .secondaryLabel }

        static var accent: UIColor { .systemBlue }

        static var danger: UIColor { .systemRed }
        static var success: UIColor { .systemGreen }
    }
}
