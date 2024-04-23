import Foundation
import UIKit

enum WeekDay: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
}

struct Tracker {
    let id: Int
    let name: String
    let color: UIColor
    let emoji: UIImage?
    let sheduler: [WeekDay]
}
