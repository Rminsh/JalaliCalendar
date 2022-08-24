//
//  Extensions+Font.swift
//  Sarrafi
//
//  Created by armin on 7/12/21.
//

import SwiftUI

struct CustomFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory

    var name: String
    
    #if os(iOS)
    var style: UIFont.TextStyle
    #elseif os(macOS)
    var style: NSFont.TextStyle
    #endif
    
    var weight: Font.Weight = .regular

    #if os(iOS)
    func body(content: Content) -> some View {
        return content.font(
            Font.custom(
                name,
                size: UIFont.preferredFont(forTextStyle: style).pointSize
            )
            .weight(weight)
        )
    }
    #elseif os(macOS)
    func body(content: Content) -> some View {
        return content.font(
            Font.custom(
                name,
                size: NSFont.preferredFont(forTextStyle: style).pointSize
            )
            .weight(weight)
        )
    }
    #endif
}

extension View {
    #if os(iOS)
    func customFont(
        name: String,
        style: UIFont.TextStyle,
        weight: Font.Weight = .regular
    ) -> some View {
        return self.modifier(CustomFont(name: name, style: style, weight: weight))
    }
    #elseif os(macOS)
    func customFont(
        name: String,
        style: NSFont.TextStyle,
        weight: Font.Weight = .regular
    ) -> some View {
        return self.modifier(CustomFont(name: name, style: style, weight: weight))
    }
    #endif
}
