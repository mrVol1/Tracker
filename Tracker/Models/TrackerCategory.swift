//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Eduard Karimov on 05/11/2023.
//

import Foundation

final class TrackerCategory: Codable {
    let label: String
    var trackers: [Tracker]

    init(label: String, trackers: [Tracker]) {
        self.label = label
        self.trackers = trackers
    }
}
