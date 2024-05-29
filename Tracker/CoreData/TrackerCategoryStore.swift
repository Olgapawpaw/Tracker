import Foundation
import UIKit
import CoreData


protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdate()
}

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Public Properties
    weak var delegate: TrackerCategoryStoreDelegate?
    
    // MARK: - Private Properties
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    private let context: NSManagedObjectContext
    
    // MARK: - Overrides Methods
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    // MARK: - Init Methods
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.name, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    // MARK: - Public Methods
    func getTrackerCategory(trackerCoreData: [TrackerCoreData]) -> [TrackerCategory] {
        //потом надо будете через запрос к бд сделать
        var nameCategory = [String]()
        var trackerCategory = [TrackerCategory]()
        var trackers = [Tracker]()
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        let trackerCategoryCoreData = try! context.fetch(request)
        
        for category in trackerCategoryCoreData {
            if !nameCategory.contains(where: {$0 == category.name}) {
                nameCategory.append(category.name ?? "Без названия")
            }
        }
        
        for name in nameCategory {
            for category in trackerCategoryCoreData {
                if name == category.name {
                    for tracker in trackerCoreData {
                        if tracker.id == category.id {
                            trackers.append(Tracker(id: tracker.id ?? UUID(),
                                                    name: tracker.name ?? "" ,
                                                    color: MarshallingColor.stringToColor(from: tracker.color ?? ""),
                                                    emoji: tracker.emoji ?? "",
                                                    sheduler: MarshallingWeekDay.stringToWeekDay(from: tracker.sheduler ?? "")))
                            break
                        }
                    }
                }
            }
            if trackers.count > 0 {
                trackerCategory.append(TrackerCategory(name: name, trackers: trackers))
                trackers.removeAll()
            }
        }
        return trackerCategory
    }
    
    func deleteTrackerCategory(_ trackerCategory: TrackerCategoryForCoreData) throws {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCategoryCoreData")
        deleteFetch.predicate = NSPredicate(format: "name == %@ AND id == %@", trackerCategory.name as CVarArg, trackerCategory.id as CVarArg)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        try context.execute(deleteRequest)
        try context.save()
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
