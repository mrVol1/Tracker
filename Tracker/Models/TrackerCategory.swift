//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Eduard Karimov on 05/11/2023.
//

import Foundation

final class TrackerCategory: Codable {
    let label: String
    var trackerMassiv: [Tracker]?

    init(label: String, trackerMassiv: [Tracker]?) {
        self.label = label
        self.trackerMassiv = trackerMassiv
    }
}
