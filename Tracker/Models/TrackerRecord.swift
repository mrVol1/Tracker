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
    let trackerId: Int
    
    init(id: UUID, date: Date, selectedDays: [WeekDay] = [], trackerId: Int) {
        self.id = id
        self.date = date
        self.selectedDays = selectedDays
        self.trackerId = trackerId
    }
}
