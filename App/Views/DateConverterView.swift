//
//  DateConverterView.swift
//  JalaliCalendar
//
//  Created by Armin on 3/19/24.
//

import SwiftUI

struct DateConverterView {
    @State var date: Date = .now
    @Environment(\.presentationMode) var presentationMode
}
    
extension DateConverterView: View {
    var body: some View {
        NavigationStack {
            ViewThatFits {
                HStack {
                    persianCalPicker
                    georgianCalPicker
                }
                .frame(minWidth: 650)
                #if os(macOS)
                .scaleEffect(1.5)
                #endif
                
                VStack {
                    persianCalPicker
                    georgianCalPicker
                }
            }
            .navigationTitle("تبدیل تاریخ")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #elseif os(macOS)
            .frame(minWidth: 500, minHeight: 300)
            #endif
            .toolbar {
                ToolbarItem {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        #if os(iOS)
                        Label("بستن", systemImage: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                        #elseif os(visionOS)
                        Label("بستن", systemImage: "xmark")
                            .symbolRenderingMode(.hierarchical)
                        #elseif os(macOS)
                        Text("بستن")
                        #endif
                    }
                    #if os(iOS) || os(macOS)
                    .buttonStyle(.plain)
                    #endif
                }
            }
        }
    }
    
    var persianCalPicker: some View {
        DatePicker("", selection: $date, displayedComponents: [.date])
            .datePickerStyle(.graphical)
            .environment(\.locale, .init(identifier: "fa"))
            .environment(\.calendar, .persianCalendar)
            #if os(iOS)
            .scaleEffect(0.8)
            #elseif os(macOS)
            #endif
    }
    
    var georgianCalPicker: some View {
        DatePicker("", selection: $date, displayedComponents: [.date])
            .datePickerStyle(.graphical)
            #if os(iOS)
            .scaleEffect(0.8)
            #endif
    }
}

#Preview {
    DateConverterView()
}
