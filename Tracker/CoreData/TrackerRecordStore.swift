import Foundation
import UIKit
import CoreData


final class TrackerRecordStore: NSObject {
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    
    // MARK: - Overrides Methods
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    // MARK: - Init Methods
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func checkExistTrackerRecord(_ trackerRecord: TrackerRecord) -> Bool {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.resultType = .countResultType
        request.predicate = NSPredicate(format: "id == %@ AND date == %@", trackerRecord.id as CVarArg, trackerRecord.date as CVarArg)
        let result = try! context.execute(request) as! NSAsynchronousFetchResult<NSFetchRequestResult>
        if result.finalResult?[0] as! Int > 0 {
            return true
        } else {
            return false
        }
    }
    
    func countTrackerRecord(_ trackerRecord: TrackerRecord) -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.resultType = .countResultType
        request.predicate = NSPredicate(format: "id == %@", trackerRecord.id as CVarArg)
        let result = try! context.execute(request) as! NSAsynchronousFetchResult<NSFetchRequestResult>
        return result.finalResult?[0] as! Int
    }
    
    func addNewTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.id = trackerRecord.id
        trackerRecordCoreData.date = trackerRecord.date
        try context.save()
    }
    
    func deleteTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerRecordCoreData")
        deleteFetch.predicate = NSPredicate(format: "id == %@ AND date == %@", trackerRecord.id as CVarArg, trackerRecord.date as CVarArg)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        try context.execute(deleteRequest)
        try context.save()
    }
}
