//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Eduard Karimov on 05/11/2023.
//

import Foundation

final class TrackerRecord {
    let id: UUID
    let date: Date
    var selectedDays: [WeekDay]
    
    init(id: UUID, date: Date, selectedDays: [WeekDay] = []) {
        self.id = id
        self.date = date
        self.selectedDays = selectedDays
    }
}
