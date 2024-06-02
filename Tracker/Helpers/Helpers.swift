import Foundation


class Helpers {
    func getNowDate() -> Date {
        let date = NSDate()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: date as Date)
        let dateWithoutTime = calendar.date(from: dateComponents)
        return dateWithoutTime ?? Date()
    }
    
    func getNowWeekday() -> Int {
        let time = NSDate()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: time as Date)
        return weekday
    }
}
