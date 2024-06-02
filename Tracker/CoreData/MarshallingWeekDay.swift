import Foundation

final class MarshallingWeekDay {
    // MARK: - Public Properties
    static func weekDayToString(from weekDay: [WeekDay]) -> String {
        var weekDayString = String()
        for i in weekDay {
            weekDayString = "\(weekDayString) \(i)"
        }
        return weekDayString
    }
    
    static func stringToWeekDay(from weekDayString: String) -> [WeekDay] {
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
