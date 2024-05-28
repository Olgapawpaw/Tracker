import Foundation
import UIKit

enum WeekDay: Int, CaseIterable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
}

enum Type: String, CaseIterable {
    case event = "event"
    case habit = "habit"
}

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: UIImage?
    let sheduler: [WeekDay]
    let type: Type
}
