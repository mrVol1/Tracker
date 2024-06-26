//
//  ColorsForHabit.swift
//  Tracker
//
//  Created by Eduard Karimov on 05/04/2024.
//

import Foundation

import UIKit

struct HabitColors {
    static let redColor = UIColor(red: 253/255, green: 76/255, blue: 73/255, alpha: 1.0)
    static let orangeColor = UIColor(red: 255/255, green: 136/255, blue: 30/255, alpha: 1.0)
    static let blueColor = UIColor(red: 0/255, green: 123/255, blue: 250/255, alpha: 1)
    static let purpleColor = UIColor(red: 110/255, green: 68/255, blue: 254/255, alpha: 1)
    static let lightGreenColor = UIColor(red: 51/255, green: 207/255, blue: 195/255, alpha: 1)
    static let lilacColor = UIColor(red: 230/255, green: 109/255, blue: 212/255, alpha: 1)
    static let palePinkColor = UIColor(red: 249/255, green: 212/255, blue: 212/255, alpha: 1)
    static let lightBlueColor = UIColor(red: 52/255, green: 167/255, blue: 254/255, alpha: 1)
    static let emeraldColor = UIColor(red: 70/255, green: 230/255, blue: 157/255, alpha: 1)
    static let darkBlueColor = UIColor(red: 53/255, green: 52/255, blue: 124/255, alpha: 1)
    static let lightRedColor = UIColor(red: 255/255, green: 103/255, blue: 77/255, alpha: 1)
    static let paleLilacColor = UIColor(red: 255/255, green: 153/255, blue: 204/255, alpha: 1)
    static let goldColor = UIColor(red: 246/255, green: 196/255, blue: 139/255, alpha: 1)
    static let skyBlueColor = UIColor(red: 121/255, green: 148/255, blue: 245/255, alpha: 1)
    static let darkLilacColor = UIColor(red: 131/255, green: 44/255, blue: 241/255, alpha: 1)
    static let lightPurpleColor = UIColor(red: 173/255, green: 86/255, blue: 218/255, alpha: 1)
    static let palePurpleColor = UIColor(red: 141/255, green: 114/255, blue: 230/255, alpha: 1)
    static let greenColor = UIColor(red: 47/255, green: 208/255, blue: 88/255, alpha: 1)
}

extension UIColor {
    func toRGBString() -> String? {
        guard let components = self.cgColor.components else {
            return nil
        }
        
        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)
        
        return String(format: "RGB(%d, %d, %d)", red, green, blue)
    }
}
