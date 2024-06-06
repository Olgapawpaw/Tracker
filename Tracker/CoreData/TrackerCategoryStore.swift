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
    private let pinCategory = NSLocalizedString("pinCategory", comment: "")
    
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
        //TODO можно переделать через запросы к БД чтобы не так жутко выглядело
        var nameCategory = [String]()
        var trackerCategory = [TrackerCategory]()
        var trackers = [Tracker]()
        var pinTrackers = [Tracker]()
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        
        do {
            let trackerCategoryCoreData = try context.fetch(request)
            
            for category in trackerCategoryCoreData {
                if !nameCategory.contains(where: {$0 == category.name}) {
                    nameCategory.append(category.name ?? "Без названия")
                }
            }
            
            for name in nameCategory {
                for category in trackerCategoryCoreData {
                    if name == category.name {
                        if name == pinCategory {
                            for tracker in trackerCoreData {
                                if tracker.id == category.id {
                                    pinTrackers.append(Tracker(id: tracker.id ?? UUID(),
                                                               name: tracker.name ?? "" ,
                                                               color: MarshallingColor.stringToColor(from: tracker.color ?? ""),
                                                               emoji: tracker.emoji ?? "",
                                                               sheduler: MarshallingWeekDay.stringToWeekDay(from: tracker.sheduler ?? "")))
                                    break
                                }
                            }
                        } else {
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
                }
                if trackers.count > 0 {
                    trackerCategory.append(TrackerCategory(name: name, trackers: trackers))
                    trackers.removeAll()
                }
            }
            if !pinTrackers.isEmpty {
                trackerCategory.insert(TrackerCategory(name: pinCategory, trackers: pinTrackers), at: 0)
            }
            return trackerCategory
        } catch let error as NSError {
            print(error.userInfo)
            return []
        }
    }
    
    func getCategoryList() -> [String] {
        var nameCategory = [String]()
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        do {
            let trackerCategoryCoreData = try context.fetch(request)
            for category in trackerCategoryCoreData {
                if !nameCategory.contains(where: {$0 == category.name}) {
                    nameCategory.append(category.name ?? "Без названия")
                }
            }
            return nameCategory
        } catch let error as NSError {
            print(error.userInfo)
            return []
        }
    }
    
    func isEmptyCategory() -> Bool {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.resultType = .countResultType
        do {
            let result = try context.execute(request) as! NSAsynchronousFetchResult<NSFetchRequestResult>
            let isPositiveValue = result.finalResult?[0] as! Int > 0
            return isPositiveValue
        } catch let error as NSError {
            print(error.userInfo)
            return Bool()
        }
    }
    
    func addNewTrackerCategory(_ name: String) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.name = name
        try context.save()
    }
    
    func getOldCategory(_ id: UUID) -> String {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let result = try context.fetch(request)
            let oldCategoryName = result[0].oldCategoryName ?? String()
            return oldCategoryName
        } catch let error as NSError {
            print(error.userInfo)
            return String()
        }
    }
    
    func deleteTrackerCategory(_ id: UUID) throws {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCategoryCoreData")
        deleteFetch.predicate = NSPredicate(format: "id == %@", id as CVarArg)
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
