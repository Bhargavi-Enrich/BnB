//
//  ExtensionGeneric.swift
//  EnrichSalon
//
//  Created by Aman Gupta on 3/22/19.
//  Copyright © 2019 Aman Gupta. All rights reserved.
//

import Foundation
import UIKit
import WebKit

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var alreadyAdded = Set<Iterator.Element>()
        return self.filter { alreadyAdded.insert($0).inserted }
    }
}

extension Encodable {

    /// Converting CodableObject to Dictionary
    func convertCodableToDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        let data = try encoder.encode(self)
        let object = try JSONSerialization.jsonObject(with: data)
        guard let json = object as? [String: Any] else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
            throw DecodingError.typeMismatch(type(of: object), context)
        }
        return json
    }

}

extension Double {
    func getPercentageInFive() -> Double {
        let selfObj = Double(self)
        let percent = 5 * (selfObj / 100)
        return percent
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    func getPercent(price: Double) -> Double {
        if price == 0 {
            return 0
        }
        let percentage: Double = 100 * ((price - self) / price)
        return percentage.rounded(toPlaces: 1)
    }
}

extension Array {
    func unique<T: Hashable>(map: ((Element) -> (T))) -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}

extension Double {
    /** How to use
 10000.asString(style: .positional)  // 2:46:40
 10000.asString(style: .abbreviated) // 2h 46m 40s
 10000.asString(style: .short)       // 2 hr, 46 min, 40 sec
 10000.asString(style: .full)        // 2 hours, 46 minutes, 40 seconds
 10000.asString(style: .spellOut)    // two hours, forty-six minutes, forty seconds
 10000.asString(style: .brief)       // 2hr 46min 40sec
    */
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
     formatter.allowedUnits = [.hour, .minute, .second]

        //formatter.allowedUnits = [.hour, .minute,.second]

        formatter.unitsStyle = .short
        guard let formattedString = formatter.string(from: self) else { return "" }
        return formattedString.replacingOccurrences(of: ",", with: "")
    }

}

extension Date {
func daySuffix() -> String {
    let calendar = Calendar.current
    let dayOfMonth = calendar.component(.day, from: self)
    switch dayOfMonth {
    case 1, 21, 31: return "st"
    case 2, 22: return "nd"
    case 3, 23: return "rd"
    default: return "th"
    }
}
}

extension Date {

    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }

}

// How to use
//if let date = Calendar.current.date(byAdding: .day, value: 20, to: Date()) {
//   print(Date().allDates(till: date))
//usage let weekday = Date().weekdayName
extension Date {

    init(day: Int,
         hour: Int = 0,
         minute: Int = 0,
         second: Int = 0,
         timeZone: TimeZone = TimeZone(abbreviation: "UTC")!) {
        var components = DateComponents()
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.timeZone = timeZone
        self = Calendar.current.date(from: components)!
    }

    func allDates(till endDate: Date) -> [Date] {
        var date = self
        var array: [Date] = []
        while date <= endDate {
            array.append(date)
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        return array
    }
    var weekdayName: String {
        let formatter = DateFormatter(); formatter.dateFormat = "E"
        return formatter.string(from: self as Date)
    }

    var weekdayNameFull: String {
        let formatter = DateFormatter(); formatter.dateFormat = "EEEE"
        return formatter.string(from: self as Date)
    }
    var dayDateName: String {
        let formatter = DateFormatter(); formatter.dateFormat = "dd"
        return formatter.string(from: self as Date)
    }

    var dayDateMonthYear: String {
        let formatter = DateFormatter(); formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: self as Date)
    }
    var dayDateMonthYearWithComma: String {
        let formatter = DateFormatter(); formatter.dateFormat = "dd MMM, yyyy"
        return formatter.string(from: self as Date)
    }

    var dayYearMonthDate: String {
        let formatter = DateFormatter(); formatter.dateFormat = "yyyy-MM-dd "
        return formatter.string(from: self as Date)
    }
    var dayMonthYearDate: String {
        let formatter = DateFormatter(); formatter.dateFormat = "dd-MM-yyyy "
        return formatter.string(from: self as Date)
    }

    var dayMonthYearFormat: String {
        let formatter = DateFormatter(); formatter.dateFormat = "dd/MM/yyyy "
        return formatter.string(from: self as Date)
    }
    
    var dayFullYear: String {
        let formatter = DateFormatter(); formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return formatter.string(from: self as Date)
    }

    var dayYearMonthDateAndTime: String {
        let formatter = DateFormatter(); formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self as Date)
    }
    var dayYearMonthDateAndTime12Hrs: String {
        let formatter = DateFormatter(); formatter.dateFormat = "MMMM dd,yyyy"
        return formatter.string(from: self as Date)
    }

    var dayYearMonthDateHyphen: String {
        let formatter = DateFormatter(); formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: self as Date)
    }

    var fullMonthDayYear: String {
        let formatter = DateFormatter(); formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: self as Date)
    }
    var monthName: String {
        let formatter = DateFormatter(); formatter.dateFormat = "MMMM"
        return formatter.string(from: self as Date)
    }

    var monthNameFirstThree: String {
        let formatter = DateFormatter(); formatter.dateFormat = "MMM"
        return formatter.string(from: self as Date)
    }

    var monthNameAndYear: String {
        let formatter = DateFormatter(); formatter.dateFormat = "MMMM  yyyy"
        return formatter.string(from: self as Date)
    }
    var OnlyYear: String {
        let formatter = DateFormatter(); formatter.dateFormat = "yyyy"
        return formatter.string(from: self as Date)
    }
    var period: String {
        let formatter = DateFormatter(); formatter.dateFormat = "a"
        return formatter.string(from: self as Date)
    }
    var timeOnly: String {
        let formatter = DateFormatter(); formatter.dateFormat = "hh : mm"
        return formatter.string(from: self as Date)
    }

    var time24Only: String {
        let formatter = DateFormatter(); formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: self as Date)
    }

    var timeWithPeriod: String {
        let formatter = DateFormatter(); formatter.dateFormat = "hh : mm a"
        return formatter.string(from: self as Date)
    }

    var timeWithPeriodNoSpace: String {
        let formatter = DateFormatter(); formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self as Date)
    }

    var DatewithMonth: String {
        let formatter = DateFormatter(); formatter.dateStyle = .medium
        return formatter.string(from: self as Date)
    }

    var dayNameDateFormat: String {
        let formatter = DateFormatter(); formatter.dateFormat = "EEE, dd MMM yyyy"
        return formatter.string(from: self as Date)
    }

    var dayNameDateNoYearFormat: String {
        let formatter = DateFormatter(); formatter.dateFormat = "EEE, dd MMM"
        return formatter.string(from: self as Date)
    }
    
    var dayNameDateNoYearFormatWithTime: String {
        let formatter = DateFormatter(); formatter.dateFormat = "EEE, dd MMM hh:mm a"
        return formatter.string(from: self as Date)
    }
    
    var dayNameDateNoYearFormatWithTimeWithAT: String {
        return self.dayNameDateFormat + " at " + self.timeWithPeriodNoSpace
    }

    var dateShortFormat: String {
        let formatter = DateFormatter(); formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: self as Date)
    }

}
extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

@IBDesignable extension UIProgressView {

    @IBInspectable var progressBarHeight: CGFloat {
        set {
            let transform = CGAffineTransform(scaleX: 1.0, y: newValue)
            self.transform = transform

        }
        get {
            return self.progressBarHeight

        }
    }

}
extension UICollectionView {
    func reloadData(_ completion: @escaping () -> Void) {
        reloadData()
        DispatchQueue.main.async { completion() }
    }
}

// USAGE
//print("Value \(distanceFloat1.clean)") // 5
//print("Value \(distanceFloat2.clean)") // 5.54
//print("Value \(distanceFloat3.clean)") // 5.03
extension Double {
    // MyProductOrdersViewController, OrderDetailsVC, ConfirmOrderVC, PaymentModeVC, PaymentModePayNowVC/ PastAppointmentDetailsVC
    var cleanForPriceFor: String {
        //return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", self) : String(format: "%.2f", self)

    }
    
    var cleanForPrice: String {
        //return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)

    }
    var cleanForRating: String {
        //return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)

    }
}

extension UIImageView {
    func setGradientToImageView() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        let colour: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
        gradient.colors = [colour.withAlphaComponent(0.0).cgColor, colour.cgColor]
        self.layer.insertSublayer(gradient, at: 0)
    }
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
extension RangeReplaceableCollection where Indices: Equatable {
    mutating func rearrange(from: Index, to: Index) {
        precondition(from != to && indices.contains(from) && indices.contains(to), "invalid indices")
        insert(remove(at: from), at: to)
    }
}


extension Date {
    // MARK: - timeAgoSinceDate
    func timeAgoSinceDate(date: NSDate, numericDates: Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date, to: latest as Date)

        if components.year! >= 2 {
            return "\(components.year!) years ago"
        }
        else if components.year! >= 1 {
            if numericDates {
                return "1 year ago"
            }
            else {
                return "Last year"
            }
        }
        else if components.month! >= 2 {
            return "\(components.month!) months ago"
        }
        else if components.month! >= 1 {
            if numericDates {
                return "1 month ago"
            }
            else {
                return "Last month"
            }
        }
        else if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear!) weeks ago"
        }
        else if components.weekOfYear! >= 1 {
            if numericDates {
                return "1 week ago"
            }
            else {
                return "Last week"
            }
        }
        else if components.day! >= 2 {
            return "\(components.day!) days ago"
        }
        else if components.day! >= 1 {
            if numericDates {
                return "1 day ago"
            }
            else {
                return "Yesterday"
            }
        }
        else if components.hour! >= 2 {
            return "\(components.hour!) hours ago"
        }
        else if components.hour! >= 1 {
            if numericDates {
                return "1 hour ago"
            }
            else {
                return "An hour ago"
            }
        }
        else if components.minute! >= 2 {
            return "\(components.minute!) minutes ago"
        }
        else if components.minute! >= 1 {
            if numericDates {
                return "1 minute ago"
            }
            else {
                return "A minute ago"
            }
        }
        else if components.second! >= 3 {
            return "\(components.second!) seconds ago"
        }
        else {
            return "Just now"
        }

    }

    /*func timeAgoDisplay() -> String {
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) sec ago"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) min ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) hrs ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) days ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) weeks ago"
    }*/
}
extension Bundle {

    var appName: String {
        guard let bundleName = infoDictionary?["CFBundleName"] as? String else
        {
            return ""
        }
        return bundleName
    }

    var bundleId: String {
        return bundleIdentifier!
    }

    var versionNumber: String {
        guard let appVersion = infoDictionary?["CFBundleShortVersionString"] as? String else
        {
            return ""
            
        }
        return appVersion
    }

    var buildNumber: String {
        guard let buildNumbe = infoDictionary?["CFBundleVersion"] as? String else
        {
            return ""
        }
        return buildNumbe
    }

}
extension WKWebView {
     func clean() {
        guard #available(iOS 9.0, *) else {return}

        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                #if DEBUG
                    print("WKWebsiteDataStore record deleted:", record)
                #endif
            }
        }
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSize = 3
        numberFormatter.secondaryGroupingSize = 2
        numberFormatter.groupingSeparator = ","
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
