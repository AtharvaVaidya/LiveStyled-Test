//
//  UIFont+Extensions.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/6/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit

extension UIFont {
    enum TextType {
        case label
        case secondaryLabel
        case button
        case headline
    }
    
    static func fontFor(textType: TextType) -> UIFont {
        switch textType {
        case .label:
            let font = UIFont.systemFont(ofSize: 18, weight: .medium).scaled(textStyle: .footnote)
            return font
        case .secondaryLabel:
            let font = UIFont.systemFont(ofSize: 14, weight: .medium).scaled(textStyle: .body)
            return font
        case .button:
            let font = UIFont.systemFont(ofSize: 16, weight: .regular).scaled(textStyle: .body)
            return font
        case .headline:
            let font = UIFont.systemFont(ofSize: 22, weight: .bold).scaled(textStyle: .headline)
            return font
        }
    }
}

extension UIFont {
    func scaled(textStyle: UIFont.TextStyle) -> UIFont {
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        let scaledFont = fontMetrics.scaledFont(for: self)
        return scaledFont
    }
}
