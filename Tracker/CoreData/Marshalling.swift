import Foundation
import UIKit

final class Marshalling {
    
    // MARK: - Public Properties
    func colorToString(from color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }
    
    func stringToColor(from hex: String) -> UIColor {
        var rgbValue:UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func weekDayToString(from weekDay: [WeekDay]) -> String {
        var weekDayString = String()
        for i in weekDay {
            weekDayString = "\(weekDayString) \(i)"
        }
        return weekDayString
    }
    
    func stringToWeekDay(from weekDayString: String) -> [WeekDay] {
        var weekDay = [WeekDay]()
        let weekDays = ["monday": WeekDay.monday, "tuesday": WeekDay.tuesday, "wednesday": WeekDay.wednesday, "thursday": WeekDay.thursday, "friday": WeekDay.friday, "saturday": WeekDay.saturday, "sunday": WeekDay.sunday]
        for i in weekDays {
            if (weekDayString.range(of: i.key)) != nil {
                weekDay.append(i.value)
            }
        }
        return weekDay
    }
}
