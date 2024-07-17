//
//  Extensions+Font.swift
//  JalaliCalendar
//
//  Created by armin on 7/12/21.
//

import SwiftUI

#if canImport(AppKit)
public typealias UXFont = NSFont
#elseif canImport(UIKit)
public typealias UXFont = UIFont
#endif

extension UXFont {
    static func custom(name: String = "Shabnam", style: UXFont.TextStyle) -> UXFont {
        return UXFont(
            name: name,
            size: UXFont.preferredFont(forTextStyle: style).pointSize
        )!
    }
}

extension Font {
    static func customFont(
        name: String = "Shabnam",
        style: UXFont.TextStyle,
        weight: Font.Weight = .regular
    ) -> Font {
        return Font
            .custom(
                name,
                size: UXFont.preferredFont(forTextStyle: style).pointSize
            )
            .weight(weight)
    }
}
