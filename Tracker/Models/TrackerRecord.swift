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
    
    init(id: UUID, date: Date) {
        self.id = id
        self.date = date
    }
}
