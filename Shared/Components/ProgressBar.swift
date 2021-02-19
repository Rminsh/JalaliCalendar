//
//  ProgressBar.swift
//  CalendarWidgetExtension
//
//  Created by armin on 2/2/21.
//

import SwiftUI

struct ProgressBar: View {
    var progress: Float
    var title: String
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5.0)
                .foregroundColor(Color("ProgressBackgroundColor"))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color("AccentColor"))
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)

            Text(title)
                .font(.custom("Shabnam-Light", size: 10))
                .foregroundColor(Color("TextColor"))
                .padding(.all, 10)
        }
    }
}
