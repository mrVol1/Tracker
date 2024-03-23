//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Eduard Karimov on 05/11/2023.
//

import Foundation

final class TrackerCategory: Codable {
    let label: String
    let trackerArray: [Tracker]?

    init(label: String, trackerArray: [Tracker]?) {
        self.label = label
        self.trackerArray = trackerArray
    }
}
