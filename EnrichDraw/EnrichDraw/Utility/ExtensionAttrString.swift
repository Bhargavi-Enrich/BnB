//
//  ExtensionAttrString.swift
//  EnrichDraw
//
//  Created by Mugdha Mundhe on 8/29/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import AVFoundation

extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        // Swift 4.1 and below
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
    func setColorForText(textForAttribute: String, withColor color: UIColor, withFont font: UIFont) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        // Swift 4.1 and below
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
}

extension String {
    
    func containsIgnoreCase(_ string: String) -> Bool {
        return self.lowercased().contains(string.lowercased())
    }
}
extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
extension String {
    func maxLength(length: Int) -> String {
        var str = self
        let nsString = str as NSString
        if nsString.length >= length {
            str = nsString.substring(with:
                NSRange(
                    location: 0,
                    length: nsString.length > length ? length : nsString.length)
            )
        }
        return  str
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    func asDictionaryOfDict() throws -> [[String: Any]] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary1 = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] else {
            throw NSError()
        }
        return dictionary1
    }
}

extension AVAudioPlayer {
    @objc func fadeOut() {
        if volume > 0.1 {
            // Fade
            volume -= 0.1
            perform(#selector(fadeOut), with: nil, afterDelay: 0.5)
        } else {
            // Stop and get the sound ready for playing again
            stop()
            prepareToPlay()
            volume = 1
        }
    }
}
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }

    func toInt() -> Int? {
        return NumberFormatter().number(from: self)?.intValue
    }
}



extension String {
    
    
    func getFormattedDateForGiftCard() -> Date {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MMMM d, yyyy" // This formate is input formated .
           if let formateDate = dateFormatter.date(from: self) {
               return formateDate
           }
        
           return Date()
       }
    
    
    func getFormattedDateForSpecialPrice() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // This formate is input formated .
        if let formateDate = dateFormatter.date(from: self) {
            return formateDate
        }
        else {
            dateFormatter.dateFormat = "yyyy-mm-dd hh:mm:ss" // This formate is input formated .
            if let formateDate = dateFormatter.date(from: self) {
                return formateDate
            }

        }
        return Date()
    }
    func getDateFromStringForMyBookings() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // This formate is input formated .
        if let formateDate = dateFormatter.date(from: self) {
            return formateDate
        }
        return Date()
    }
    func getDateFromStringForMyProfileScreen(dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat // This formate is input formated .
        if let formateDate = dateFormatter.date(from: self) {
            return formateDate
        }
        return Date()
    }

    func getFormattedDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // This formate is input formated .
        if let formateDate = dateFormatter.date(from: self) {
            return formateDate
        }
        else {
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss" // This formate is input formated .
            if let formateDate = dateFormatter.date(from: self) {
                return formateDate
            }

        }
        return Date()
    }

    func getFormattedDateForEditProfile() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // This formate is input formated .
        if let formateDate = dateFormatter.date(from: self) {
            return formateDate
        }
        return Date()
    }

    func getTimeInDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" // This formate is input formated .
        if let formateDate = dateFormatter.date(from: self) {
            return formateDate
        }
        return Date()
    }

    func getTimeInDate24Hrs() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss" // This formate is input formated .
        if let formateDate = dateFormatter.date(from: self) {
            return formateDate
        }
        return Date()
    }

    func getFormattedDatehh() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // This formate is input formated .

        if let formateDate = dateFormatter.date(from: self) {
            return formateDate
        }
        else {
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss" // This formate is input formated .
            if let formateDate = dateFormatter.date(from: self) {
                return formateDate
            }

        }
        return Date()
    }
    
    func getFormattedDatehhSlotView() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a" // This formate is input formated .

        if let formateDate = dateFormatter.date(from: self) {
            return formateDate
        }
        else {
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a" // This formate is input formated .
            if let formateDate = dateFormatter.date(from: self) {
                return formateDate
            }

        }
        return Date()
    }
    
    func getFormattedFullDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"  // This formate is input formated .

        if let formateDate = dateFormatter.date(from: self) {
            return formateDate
        }
        else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"  // This formate is input formated .
            if let formateDate = dateFormatter.date(from: self) {
                return formateDate
            }

        }
        return Date()
    }



}
