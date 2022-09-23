//
//  ProgressBar.swift
//  CalendarWidgetExtension
//
//  Created by armin on 2/2/21.
//

import SwiftUI

struct GaugeView: View {
    var progress: Float
    var title: String
    
    var body: some View {
        ZStack {
            if #available(iOS 16.0, macOS 13.0, *) {
                Gauge(value: progress) {
                    Text(title)
                        .customFont(name: "Shabnam", style: .callout, weight: .light)
                        .foregroundColor(Color("TextColor"))
                }
                .tint(Color("AccentColor"))
                .gaugeStyle(.accessoryCircularCapacity)
            } else {
                CustomGauge(progress: progress, title: title)
                    .frame(maxWidth: 50, maxHeight: 50)
            }
        }
    }
}
struct CustomGauge: View {
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
                .animation(.linear, value: self.progress)

            Text(title)
                .customFont(name: "Shabnam-Light", style: .callout, weight: .light)
                .minimumScaleFactor(0.8)
                .foregroundColor(Color("TextColor"))
                .padding(.all, 12)
        }
    }
}

struct GaugeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            GaugeView(progress: 0.8, title: "ماه")
        }
    }
}
