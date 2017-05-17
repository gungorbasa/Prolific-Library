//
//  DateExtension.swift
//  The Prolific Library
//
//  Created by Gungor Basa on 5/15/17.
//  Copyright © 2017 Gungor Basa. All rights reserved.
//

import Foundation

extension Date {
    mutating func toDate(dateStr: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        if let _date = dateFormatter.date(from: dateStr) {
            self = _date
        }
    }
    
    static func toString(date: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
}
