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
    private let marshalling = Marshalling()
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
        var tracker = [Tracker]()
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        let trackerCategoryCoreData = try! context.fetch(request)
        
        for i in trackerCategoryCoreData {
            if nameCategory.contains(where: {$0 == i.name}) == false {
                nameCategory.append(i.name ?? "")
            }
        }
        
        for i in nameCategory {
            for j in trackerCategoryCoreData {
                if i == j.name {
                    for k in trackerCoreData {
                        if k.id == j.id {
                            tracker.append(Tracker(id: k.id!,
                                                   name: k.name!,
                                                   color: marshalling.stringToColor(from: k.color!),
                                                   emoji: k.emoji!,
                                                   sheduler: marshalling.stringToWeekDay(from: k.sheduler!)))
                            break
                        }
                    }
                }
            }
            if tracker.count > 0 {
                trackerCategory.append(TrackerCategory(name: i, trackers: tracker))
                tracker.removeAll()
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
