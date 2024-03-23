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
    let color: String
    let emodji: String
    let timetable: [WeekDay]

    init(id: UUID, name: String, color: String, emodji: String, timetable: [WeekDay]) {
        self.id = id
        self.name = name
        self.color = color
        self.emodji = emodji
        self.timetable = timetable
    }
}
