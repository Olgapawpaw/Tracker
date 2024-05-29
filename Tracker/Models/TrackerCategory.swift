import Foundation
import UIKit


struct TrackerCategoryForCoreData {
    let name: String
    var id: UUID
}

struct TrackerCategory {
    let name: String
    var trackers: [Tracker]
}
