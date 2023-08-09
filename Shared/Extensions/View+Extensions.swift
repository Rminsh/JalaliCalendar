//
//  View+Extensions.swift
//  JalaliCalendar
//
//  Created by Armin on 8/9/23.
//

import SwiftUI

extension View {
    @inlinable func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask(
            ZStack {
                Rectangle()
                
                mask()
                    .blendMode(.destinationOut)
            }
        )
    }
}
