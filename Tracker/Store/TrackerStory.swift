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
                       scheduleDays: [WeekDay],
                       categoryLabel: String) -> Tracker? {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        // Проверяем, существует ли категория с указанным именем
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "label == %@", categoryLabel)

        do {
            let categories = try managedContext.fetch(fetchRequest)
            if let category = categories.first {
                // Категория существует, используем её для создания трекера
                guard let trackerEntity = NSEntityDescription.entity(forEntityName: "TrackerCoreData", in: managedContext) else {
                    fatalError("Entity description for TrackerCoreData not found")
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
                trackerManagedObject.setValue(category, forKey: "category")

                // Сохраняем изменения в контексте
                try managedContext.save()
                print("Tracker saved successfully.")

                // Возвращаем созданный трекер
                return Tracker(id: trackerId, name: name, color: color, emoji: emoji, timetable: scheduleDays, category: categoryLabel)
            } else {
                // Категория не существует, создаем новую категорию
                let newCategory = TrackerCategoryStore.shared.createTrackerCategory(label: categoryLabel, trackers: [])
                if newCategory != nil {
                    return createTracker(name: name, color: color, emoji: emoji, scheduleDays: scheduleDays, categoryLabel: categoryLabel)
                } else {
                    return nil
                }
            }
        } catch {
            // Ошибка при запросе категории из базы данных
            print("Error fetching category: \(error)")
            return nil
        }
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
        trackerManagedObject.setValue(tracker.emoji, forKey: "emoji")
        
        let transformer = TransformerValue()
        if let transformedDays = transformer.transformedValue(tracker.timetable) as? NSData {
            trackerManagedObject.setValue(transformedDays, forKey: "timetable")
        }
        
        trackerManagedObject.setValue(tracker.category, forKey: "category") // добавляем категорию
        
        do {
            try managedContext.save()
            print("Tracker saved successfully.")
        } catch let error as NSError {
            print("Could not save tracker. \(error), \(error.userInfo)")
        }
    }
}
