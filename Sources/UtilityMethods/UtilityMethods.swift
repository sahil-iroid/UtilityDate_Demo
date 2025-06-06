// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@MainActor
public class UtilityMethodsDate: NSObject {
    
    // MARK: - Change Date Format
    //for displaying in local
    public class func changeDateFormat(date:String, dateFormat:String, getFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = (dateFormatter.date(from: date) ?? nil) ?? Date()
        dateFormatter.dateFormat = getFormat
        let resultString = dateFormatter.string(from: date)
        print(resultString)
        return resultString
    }

}
