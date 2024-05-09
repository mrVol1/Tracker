//
//  Tracker.swift
//  Tracker
//
//  Created by Eduard Karimov on 05/11/2023.
//

import Foundation

enum WeekDay: String, CaseIterable, Codable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
}

final class Tracker: Codable {
    let id: UUID
    let name: String
    let color: Set<IndexPath>
    let emodji: Set<IndexPath>
    let timetable: [WeekDay]

    init(id: UUID, name: String, color: Set<IndexPath>, emodji: Set<IndexPath>, timetable: [WeekDay]) {
        self.id = id
        self.name = name
        self.color = color
        self.emodji = emodji
        self.timetable = timetable
    }
}
