//
//  DateValue.swift
//  DASMobile
//
//  Created by İlker Kaya on 31.05.2023.
//

import Foundation

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
