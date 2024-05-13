//
//  TrackerStory.swift
//  Tracker
//
//  Created by Eduard Karimov on 13/05/2024.
//

import Foundation
import CoreData
import UIKit

class TrackerStore {
    
    static let shared = TrackerStore()
    
    private init() {}
    
    func createTracker(name: String,
                       color: String,
                       emoji: String,
                       scheduleDays: [WeekDay]) -> NSManagedObject? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let trackerEntity = NSEntityDescription.entity(forEntityName: "TrackerCoreData", in: managedContext) else {
            fatalError("Entity description for Tracker not found")
        }
        
        let tracker = NSManagedObject(entity: trackerEntity, insertInto: managedContext)
        
        tracker.setValue(name, forKey: "name")
        tracker.setValue(color, forKey: "color")
        tracker.setValue(emoji, forKey: "emoji")
        tracker.setValue(UUID(), forKey: "id")
        
        let transformer = TransformerValue()
        
        if let transformedDays = transformer.transformedValue(scheduleDays) as? NSData {
            tracker.setValue(transformedDays, forKey: "timetable")
        }
        
        return tracker
    }
    
    func saveTracker(_ tracker: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            try managedContext.save()
            print("Tracker saved successfully.")
        } catch let error as NSError {
            print("Could not save tracker. \(error), \(error.userInfo)")
        }
    }
}

