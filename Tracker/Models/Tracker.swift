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

final class Tracker: NSObject, NSSecureCoding, Codable {
    static var supportsSecureCoding: Bool {
        return true
    }

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

    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as? UUID,
              let name = aDecoder.decodeObject(forKey: "name") as? String,
              let color = aDecoder.decodeObject(forKey: "color") as? String,
              let emodji = aDecoder.decodeObject(forKey: "emodji") as? String,
              let timetable = aDecoder.decodeObject(forKey: "timetable") as? [WeekDay] else {
            return nil
        }

        self.init(id: id, name: name, color: color, emodji: emodji, timetable: timetable)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(color, forKey: "color")
        aCoder.encode(emodji, forKey: "emodji")
        aCoder.encode(timetable, forKey: "timetable")
    }
}
