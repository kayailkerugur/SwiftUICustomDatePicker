//
//  SwiftUICustomDatePickerApp.swift
//  SwiftUICustomDatePicker
//
//  Created by İlker Kaya on 5.06.2023.
//

import SwiftUI

@main
struct SwiftUICustomDatePickerApp: App {
    @State var currentDate: Date = Date()

    var body: some Scene {
        WindowGroup {
            ContentView(currentDate: $currentDate)
        }
    }
}
