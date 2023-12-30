//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Eduard Karimov on 05/11/2023.
//

import Foundation

final class TrackerCategory: NSObject, NSCoding {
    let label: String
    let trackerMassiv: [Tracker]
    
    init(label: String, trackerMassiv: [Tracker]) {
        self.label = label
        self.trackerMassiv = trackerMassiv
    }

    // Методы для соответствия NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(label, forKey: "label")
        coder.encode(trackerMassiv, forKey: "trackerMassiv")
    }

    required init?(coder: NSCoder) {
        guard let label = coder.decodeObject(forKey: "label") as? String,
              let trackerMassiv = coder.decodeObject(forKey: "trackerMassiv") as? [Tracker]
        else {
            return nil
        }

        self.label = label
        self.trackerMassiv = trackerMassiv
    }
}




