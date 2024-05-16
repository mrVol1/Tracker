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
                       scheduleDays: [WeekDay]) -> Tracker? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let trackerEntity = NSEntityDescription.entity(forEntityName: "TrackerCoreData", in: managedContext) else {
            fatalError("Entity description for Tracker not found")
        }
        
        let trackerManagedObject = NSManagedObject(entity: trackerEntity, insertInto: managedContext)
        
        let trackerId = UUID()
        let transformer = TransformerValue()
        let transformedDays = transformer.transformedValue(scheduleDays) as? NSData
        
        trackerManagedObject.setValue(name, forKey: "name")
        trackerManagedObject.setValue(color, forKey: "color")
        trackerManagedObject.setValue(emoji, forKey: "emoji")
        trackerManagedObject.setValue(trackerId, forKey: "id")
        trackerManagedObject.setValue(transformedDays, forKey: "timetable")
        
        do {
            try managedContext.save()
            print("Tracker saved successfully.")
        } catch let error as NSError {
            print("Could not save tracker. \(error), \(error.userInfo)")
            return nil
        }
        
        return Tracker(id: trackerId, name: name, color: color, emodji: emoji, timetable: scheduleDays)
    }
    
    func saveTracker(_ tracker: Tracker) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let trackerEntity = NSEntityDescription.entity(forEntityName: "TrackerCoreData", in: managedContext) else {
            fatalError("Entity description for Tracker not found")
        }
        
        let trackerManagedObject = NSManagedObject(entity: trackerEntity, insertInto: managedContext)
        
        trackerManagedObject.setValue(tracker.id, forKey: "id")
        trackerManagedObject.setValue(tracker.name, forKey: "name")
        trackerManagedObject.setValue(tracker.color, forKey: "color")
        trackerManagedObject.setValue(tracker.emodji, forKey: "emoji")
        
        let transformer = TransformerValue()
        if let transformedDays = transformer.transformedValue(tracker.timetable) as? NSData {
            trackerManagedObject.setValue(transformedDays, forKey: "timetable")
        }
        
        do {
            try managedContext.save()
            print("Tracker saved successfully.")
        } catch let error as NSError {
            print("Could not save tracker. \(error), \(error.userInfo)")
        }
    }
}
