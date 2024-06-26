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
    let emoji: String
    let timetable: [WeekDay]
    var category: String?

    init(id: UUID, name: String, color: String, emoji: String, timetable: [WeekDay], category: String?) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.timetable = timetable
        self.category = category
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as? UUID,
              let name = aDecoder.decodeObject(forKey: "name") as? String,
              let color = aDecoder.decodeObject(forKey: "color") as? String,
              let emoji = aDecoder.decodeObject(forKey: "emoji") as? String,
              let timetable = aDecoder.decodeObject(forKey: "timetable") as? [WeekDay],
              let category = aDecoder.decodeObject(forKey: "category") as? String
        else {
            return nil
        }

        self.init(id: id, name: name, color: color, emoji: emoji, timetable: timetable, category: category)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(color, forKey: "color")
        aCoder.encode(emoji, forKey: "emoji")
        aCoder.encode(timetable, forKey: "timetable")
        aCoder.encode(category, forKey: "category")
    }
}
