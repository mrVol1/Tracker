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
    
    func createTrackerCategory(label: String, trackers: [Tracker]) -> NSManagedObject? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let categoryEntity = NSEntityDescription.entity(forEntityName: "TrackerCategoryCoreData", in: managedContext) else {
            fatalError("Entity description for TrackerCategory not found")
        }
        
        let categoryManagedObject = NSManagedObject(entity: categoryEntity, insertInto: managedContext)
        
        categoryManagedObject.setValue(label, forKey: "label")
        
        do {
            let jsonEncoder = JSONEncoder()
            let trackersData = try jsonEncoder.encode(trackers)
            
            categoryManagedObject.setValue(trackersData, forKey: "trackerArray")
            
            try managedContext.save()
            print("TrackerCategory saved successfully.")
            return categoryManagedObject
        } catch let error as NSError {
            print("Could not save tracker category. \(error), \(error.userInfo)")
            return nil
        }
    }
}
