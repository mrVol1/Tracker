//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Eduard Karimov on 13/05/2024.
//

import Foundation
import CoreData
import UIKit

class TrackerCategoryStore {
    
    static let shared = TrackerCategoryStore()
        
    private init() {}
    
    func createTrackerCategory(label: String, trackers: [Tracker]) -> TrackerCategoryCoreData? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let categoryEntity = NSEntityDescription.entity(forEntityName: "TrackerCategoryCoreData", in: managedContext) else {
            fatalError("Entity description for TrackerCategoryCoreData not found")
        }
        
        let categoryManagedObject = TrackerCategoryCoreData(entity: categoryEntity, insertInto: managedContext)
        categoryManagedObject.label = label
        
        for tracker in trackers {
            if let newTracker = TrackerStore.shared.createTracker(name: tracker.name,
                                                                   color: tracker.color,
                                                                   emoji: tracker.emoji,
                                                                   scheduleDays: tracker.timetable,
                                                                   categoryLabel: label) {
                let trackerEntity = NSEntityDescription.entity(forEntityName: "TrackerCoreData", in: managedContext)!
                let trackerManagedObject = TrackerCoreData(entity: trackerEntity, insertInto: managedContext)
                
                trackerManagedObject.id = newTracker.id
                trackerManagedObject.name = newTracker.name
                trackerManagedObject.color = newTracker.color
                trackerManagedObject.emoji = newTracker.emoji
                trackerManagedObject.timetable = newTracker.timetable as NSObject
                
                categoryManagedObject.addToTrackers(trackerManagedObject)
            }
        }
        
        do {
            try managedContext.save()
            print("TrackerCategory saved successfully.")
            return categoryManagedObject
        } catch let error as NSError {
            print("Could not save tracker category. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            try managedContext.save()
            print("Changes saved successfully.")
        } catch let error as NSError {
            print("Could not save changes. \(error), \(error.userInfo)")
        }
    }
}

extension TrackerCategoryCoreData {
    @objc(addTrackersObject:)
    @NSManaged public func addToTrackers(_ value: TrackerCoreData)

    @objc(removeTrackersObject:)
    @NSManaged public func removeFromTrackers(_ value: TrackerCoreData)

    @objc(addTrackers:)
    @NSManaged public func addToTrackers(_ values: NSSet)

    @objc(removeTrackers:)
    @NSManaged public func removeFromTrackers(_ values: NSSet)
}

