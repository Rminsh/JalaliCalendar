//
//  Extensions+Font.swift
//  JalaliCalendar
//
//  Created by armin on 7/12/21.
//

import SwiftUI

#if os(macOS)
public typealias UXFont = NSFont
#elseif os(iOS)
public typealias UXFont = UIFont
#endif

struct CustomFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory

    var name: String
    var style: UXFont.TextStyle
    var weight: Font.Weight = .regular

    func body(content: Content) -> some View {
        return content
            .font(
                .custom(name, size: UXFont.preferredFont(forTextStyle: style).pointSize)
                .weight(weight)
            )
    }
}

extension View {
    func customFont(
        name: String = "Shabnam",
        style: UXFont.TextStyle,
        weight: Font.Weight = .regular
    ) -> some View {
        return self.modifier(CustomFont(name: name, style: style, weight: weight))
    }
}
