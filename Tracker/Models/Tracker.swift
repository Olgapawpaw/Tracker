import Foundation
import UIKit


enum WeekDay: Int, CaseIterable, Encodable, Decodable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
}

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let sheduler: [WeekDay]
}
