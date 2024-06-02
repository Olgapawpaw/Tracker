import Foundation
import UIKit
import CoreData


final class TrackerStore: NSObject {
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private var weekDay = [1: "sunday", 2: "monday", 3: "tuesday", 4: "wednesday", 5: "thursday", 6: "friday", 7: "saturday"]
    
    // MARK: - Overrides Methods
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    // MARK: - Init Methods
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    // MARK: - Public Methods
    func checkExistTrackers() -> Bool {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.resultType = .countResultType
        do {
            let result = try context.execute(request) as! NSAsynchronousFetchResult<NSFetchRequestResult>
            if result.finalResult?[0] as! Int > 0 {
                return false
            } else {
                return true
            }
        } catch let error as NSError {
            print(error.userInfo)
            return Bool()
        }
    }
    
    func getSelectedTrackers(day: Int) throws -> [TrackerCoreData] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "sheduler CONTAINS[n] %@", (weekDay[day] as CVarArg? ?? String()))
        do {
            let result = try context.fetch(request)
            return result
        } catch let error as NSError {
            print(error.userInfo)
            return []
        }
    }
    
    func getSearchTrackers(text: String, day: Int) throws -> [TrackerCoreData] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@ AND sheduler CONTAINS[n] %@", text, (weekDay[day] as CVarArg? ?? String()))
        do {
            let result = try context.fetch(request)
            return result
        } catch let error as NSError {
            print(error.userInfo)
            return []
        }
    }
    
    func addNewTracker(_ tracker: Tracker, trackerCategory: TrackerCategoryForCoreData) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.id = trackerCategory.id
        trackerCategoryCoreData.name = trackerCategory.name
        trackerCoreData.category = trackerCategoryCoreData
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = MarshallingColor.colorToString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.sheduler = MarshallingWeekDay.weekDayToString(from: tracker.sheduler)
        try context.save()
    }
}
