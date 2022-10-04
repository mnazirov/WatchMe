//
//  CustomDatesFormatter.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import Foundation

final class CustomDatesFormatter {
    
    func customDate(year: Int, month: Int, day: Int) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        guard let formattedDate = formatter.date(from: "\(day)/\(month)/\(year)") else { fatalError("Can't create custom date") }
        return formattedDate
    }
    
    func shortDateFormat(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier:"ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
        dateFormatter.dateStyle = .short
        
        return dateFormatter.string(from: date)
    }
    
    func dateToString(with date: Date) -> String {
        if date.isInToday {
            return "Сегодня"
        } else if date.isInYesterday {
            return "Вчера"
        } else {
            return shortDateFormat(with: date)
        }
    }
}
