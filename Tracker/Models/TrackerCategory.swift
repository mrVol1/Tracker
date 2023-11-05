//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Eduard Karimov on 05/11/2023.
//

import Foundation

final class TrackerCategory {
    let label: String
    let trackerMassiv: Tracker
    
    init(label: String, trackerMassiv: Tracker) {
        self.label = label
        self.trackerMassiv = trackerMassiv
    }
}
