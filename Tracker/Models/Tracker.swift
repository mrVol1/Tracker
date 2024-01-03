//
//  Tracker.swift
//  Tracker
//
//  Created by Eduard Karimov on 05/11/2023.
//

import Foundation

final class Tracker: Codable {
    let id: Int
    let name: String
    let color: String
    let emodji: String
    let timetable: String

    init(id: Int, name: String, color: String, emodji: String, timetable: String) {
        self.id = id
        self.name = name
        self.color = color
        self.emodji = emodji
        self.timetable = timetable
    }
}
