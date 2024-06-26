//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Eduard Karimov on 05/11/2023.
//

import Foundation

final class TrackerRecord {
    let date: Date
    let trackerId: UUID
    
    init(date: Date,  trackerId: UUID) {
        self.date = date
        self.trackerId = trackerId
    }
}
