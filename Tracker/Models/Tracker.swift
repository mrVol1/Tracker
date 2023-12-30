//
//  Tracker.swift
//  Tracker
//
//  Created by Eduard Karimov on 05/11/2023.
//

import Foundation

final class Tracker: NSObject, NSCoding {
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

    // MARK: - NSCoding

    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        let color = aDecoder.decodeObject(forKey: "color") as? String ?? ""
        let emodji = aDecoder.decodeObject(forKey: "emodji") as? String ?? ""
        let timetable = aDecoder.decodeObject(forKey: "timetable") as? String ?? ""

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

