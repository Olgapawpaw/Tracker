import Foundation
import UIKit


struct TrackerCategoryForCoreData {
    let name: String
    let id: UUID
    let oldCategoryName: String?
}

struct TrackerCategory {
    let name: String
    var trackers: [Tracker]
}
