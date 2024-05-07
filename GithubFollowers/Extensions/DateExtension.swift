//
//  DateExtension.swift
//  GithubFollowers
//
//  Created by Cami Mamedov on 07.05.24.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
}
