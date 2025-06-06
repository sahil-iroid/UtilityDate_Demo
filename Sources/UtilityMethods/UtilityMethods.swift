// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

class UtilityMethodsDate: NSObject {
    
    // MARK: - Change Date Format
    //for displaying in local
    class func changeDateFormat(date:String, dateFormat:String, getFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = (dateFormatter.date(from: date) ?? nil) ?? Date()
        dateFormatter.dateFormat = getFormat
        let resultString = dateFormatter.string(from: date)
        print(resultString)
        return resultString
    }
    
    // MARK: - Local to UTC
    //for sending UTC date/time to the backend
    class func localToUTC(date:String, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        
        let utcDateString = date
        if let utcDate = dateFormatter.date(from: utcDateString ) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let convertedDateString = dateFormatter.string(from: utcDate)
            print(convertedDateString)
            
            return convertedDateString
        }
        return ""
    }
    
    // MARK: - Convert Time-stamp to Date
    class func convertTimestampToDate(timestamp: TimeInterval, format: String) -> String {
        let date = Date(timeIntervalSince1970: timestamp/1000)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: date)
    }
    
    // MARK: - UTC to Local
    class func UTCToLocalForChat(timeStamp: NSNumber, toFormat: String) -> String {
        let myTimeInterval = TimeInterval(truncating: timeStamp) / 1000
        let date = Date(timeIntervalSince1970: myTimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Time Ago
    class func timeAgoSinceDate(dateInMilliseconds: Double) -> String {
        let date = Date(timeIntervalSince1970: dateInMilliseconds / 1000)
        let now = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: date, to: now)
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        } else if let year = components.year, year >= 1 {
            return "Last year"
        } else if let month = components.month, month >= 2 {
            return "\(month) months ago"
        } else if let month = components.month, month >= 1 {
            return "Last month"
        } else if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        } else if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        } else if let day = components.day, day >= 2 {
            return "\(day) days ago"
        } else if let day = components.day, day >= 1 {
            return "Yesterday"
        } else if let hour = components.hour, hour >= 2 {
            return "\(hour) hrs ago"
        } else if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        } else if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        } else if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        } else if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        } else {
            return "Just now"
        }
    }
    
    // MARK: - Get Date Time Stamp
//    class func getDateTimeStamp(date:Date) -> Date {
//        let date = UtilityMethodsDate.localToUTC(fromFormat: date.dateFormatWithSuffix(), toFormat: "yyyy-MM-dd HH:mm:ss z", dateValue: date)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
//        let string = date                 // "March 24, 2017 at 7:00 AM"
//        let finalDate = dateFormatter.date(from: string)
//        return finalDate!
//    }
    
    class func localToUTC(fromFormat: String, toFormat: String,dateValue:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.dateFormat = toFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        print(dateFormatter.string(from: date))
//        dateFormatter.calendar = NSCalendar.current
//        dateFormatter.timeZone = NSTimeZone.local
//        let dt = dateFormatter.date(from: date)
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: dateValue)
    }
    
    // MARK: - Local to UTC in Availability flow
    // Convert local time to UTC for sending to backend
    ///only for Availability flow
    class func localToUTCAvailabilityFlow(timeString: String, inputFormat: String = "h:mm a", outputFormat: String = "HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        dateFormatter.timeZone = TimeZone.current  // Set to local time zone for parsing
        
        guard let localDate = dateFormatter.date(from: timeString) else {
            print("Invalid time string: \(timeString)")
            return ""
        }
        
        // For proper time zone conversion, we need a full date
        // As time zones depend on dates (daylight saving etc.)
        // But if we're only concerned with the time portion, we can use any date
        // Create a calendar with current time zone
        let calendar = Calendar.current
        
        // Extract just the hour and minute
        let components = calendar.dateComponents([.hour, .minute], from: localDate)
        
        // Use today's date with the extracted time
        let today = Date()
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        
        var combinedComponents = DateComponents()
        combinedComponents.year = todayComponents.year
        combinedComponents.month = todayComponents.month
        combinedComponents.day = todayComponents.day
        combinedComponents.hour = components.hour
        combinedComponents.minute = components.minute
        
        guard let fullDateTime = calendar.date(from: combinedComponents) else {
            print("Failed to create date with components")
            return ""
        }
        
        // Now format in UTC
        dateFormatter.dateFormat = outputFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: fullDateTime)
    }
    
    // MARK: - Convert time string to local for the streaming
    class func convertUTCTimeToLocalForStreaming(timeInString: String) -> String? {
        // Parse the time string in the local time zone
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        timeFormatter.timeZone = TimeZone.current
        
        guard let time = timeFormatter.date(from: timeInString) else {
            return nil
        }
        
        // Format the time to "h:mm a"
        timeFormatter.dateFormat = "h:mm a"
        return timeFormatter.string(from: time)
    }
    
    // MARK: - Convert time string to local for the blasts
    class func convertUTCToLocalTimeForBlasts(fromTime: String, toTime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC") // Set UTC time zone
        
        guard let fromDate = dateFormatter.date(from: fromTime),
              let toDate = dateFormatter.date(from: toTime) else {
            return ""
        }
        
        // Convert to local time
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mma" // Format in 12-hour format with AM/PM
        
        let fromTimeString = dateFormatter.string(from: fromDate).lowercased()
        let toTimeString = dateFormatter.string(from: toDate).lowercased()
        
#if DEBUG
        print("fromTimeString --> \(fromTimeString)")
        print("toTimeString --> \(toTimeString)")
#endif
        
        return "\(fromTimeString) - \(toTimeString)"
    }
    
    // MARK: - Convert UTC time strings to local for blasts
    ///considering date also
    class func convertUTCToLocalTimeForBlastsConsideringDate(fromTime: String, toTime: String, timestampMs: Double) -> String {
        let dateFormatter = DateFormatter()
        
        // Convert UTC timestamp to Date object
        let eventDate = Date(timeIntervalSince1970: timestampMs / 1000)
        
        // Extract date components from the timestamp
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: eventDate)
        
        // Parse the UTC time strings
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        // Parse from time
        guard let fromTimeDate = dateFormatter.date(from: fromTime) else {
            print("Failed to parse from time: \(fromTime)")
            return "\(fromTime) - \(toTime)" // Fallback to original times
        }
        
        // Parse to time
        guard let toTimeDate = dateFormatter.date(from: toTime) else {
            print("Failed to parse to time: \(toTime)")
            return "\(fromTime) - \(toTime)" // Fallback to original times
        }
        
        // Extract time components
        let fromTimeComponents = calendar.dateComponents([.hour, .minute, .second], from: fromTimeDate)
        let toTimeComponents = calendar.dateComponents([.hour, .minute, .second], from: toTimeDate)
        
        // Create the full UTC date-time for from_time
        var fromComponents = DateComponents()
        fromComponents.year = dateComponents.year
        fromComponents.month = dateComponents.month
        fromComponents.day = dateComponents.day
        fromComponents.hour = fromTimeComponents.hour
        fromComponents.minute = fromTimeComponents.minute
        fromComponents.second = fromTimeComponents.second
        
        // Create the full UTC date-time for to_time
        var toComponents = DateComponents()
        toComponents.year = dateComponents.year
        toComponents.month = dateComponents.month
        toComponents.day = dateComponents.day
        toComponents.hour = toTimeComponents.hour
        toComponents.minute = toTimeComponents.minute
        toComponents.second = toTimeComponents.second
        
        // Create UTC date-time objects
        guard let fromUTCDateTime = calendar.date(from: fromComponents),
              let toUTCDateTime = calendar.date(from: toComponents) else {
            print("Failed to create full date-time objects")
            return "\(fromTime) - \(toTime)" // Fallback to original times
        }
        
        // Handle multi-day events (if to_time is before from_time)
        var adjustedToUTCDateTime = toUTCDateTime
        if toTimeComponents.hour! < fromTimeComponents.hour! {
            // Add one day to the end time if it appears to be the next day
            adjustedToUTCDateTime = calendar.date(byAdding: .day, value: 1, to: toUTCDateTime) ?? toUTCDateTime
        }
        
        // Convert to local time zone and format for display
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mma" // Format in 12-hour format with AM/PM
        
        let fromLocalTimeString = dateFormatter.string(from: fromUTCDateTime).lowercased()
        let toLocalTimeString = dateFormatter.string(from: adjustedToUTCDateTime).lowercased()
        
        return "\(fromLocalTimeString) - \(toLocalTimeString)"
    }
    
    // MARK: - Convert UTC 24-hour time string to Local time string
    class func convertUTCTimeStringToLocalTimeString(date: String, inputFormat: String = "HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let date = dateFormatter.date(from: date) else { return date }
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm a" // Output in 12-hour format with AM/PM
        
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Convert UTC time to local time for display in Availability flow
    ///only for Availability flow
    class func convertUTCTimeStringToLocalTimeStringAvailabilityFlow(date: String, inputFormat: String = "HH:mm:ss", outputFormat: String = "h:mm a") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let utcDate = dateFormatter.date(from: date) else {
            print("Invalid UTC time string: \(date)")
            return date // Return original string if conversion fails
        }
        
        // Like in the localToUTC1 method, we need a full date for proper conversion
        // The date component is arbitrary - we only care about the time part
        // But including a full date ensures timezone conversion works correctly
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: utcDate)
    }
    
    // MARK: - Convert date to UTC while considering timezone impact
    class func convertDateToUTCConsideringTimezone(dateString: String,
                               localTimeString: String, // Consider time for proper conversion
                               dateFormat: String = "dd-MM-yyyy",
                               timeFormat: String = "h:mm a",
                               outputDateFormat: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        
        // Parse the date
        dateFormatter.dateFormat = dateFormat
        guard let parsedDate = dateFormatter.date(from: dateString) else {
            print("Failed to parse date: \(dateString)")
            return ""
        }
        
        // Parse the time
        dateFormatter.dateFormat = timeFormat
        guard let parsedTime = dateFormatter.date(from: localTimeString) else {
            print("Failed to parse time: \(localTimeString)")
            return ""
        }
        
        // Combine date and time for proper timezone conversion
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: parsedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: parsedTime)
        
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        
        guard let localDateTime = calendar.date(from: combinedComponents) else {
            print("Failed to create combined date-time")
            return ""
        }
        
        // Convert to UTC and format as date-only
        dateFormatter.dateFormat = outputDateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return dateFormatter.string(from: localDateTime)
    }

    // MARK: - Convert time to UTC while considering date for proper timezone conversion
    class func convertTimeToUTCConsideringDate(timeString: String,
                               dateString: String, // Consider date for proper conversion
                               timeFormat: String = "h:mm a",
                               dateFormat: String = "dd-MM-yyyy",
                               outputTimeFormat: String = "HH:mm") -> String {
        let dateFormatter = DateFormatter()
        
        // Parse the time
        dateFormatter.dateFormat = timeFormat
        guard let parsedTime = dateFormatter.date(from: timeString) else {
            print("Failed to parse time: \(timeString)")
            return ""
        }
        
        // Parse the date
        dateFormatter.dateFormat = dateFormat
        guard let parsedDate = dateFormatter.date(from: dateString) else {
            print("Failed to parse date: \(dateString)")
            return ""
        }
        
        // Combine date and time for proper timezone conversion
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: parsedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: parsedTime)
        
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        
        guard let localDateTime = calendar.date(from: combinedComponents) else {
            print("Failed to create combined date-time")
            return ""
        }
        
        // Convert to UTC and format as time-only
        dateFormatter.dateFormat = outputTimeFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return dateFormatter.string(from: localDateTime)
    }
    
    // MARK: - Convert UTC time string to local time string with date context
    ///Convert UTC time string to local time string (with date context)
    class func convertUTCTimeToLocalConsideringDate(utcTime: String,
                                    utcDate: String,
                                    utcTimeFormat: String = "HH:mm",
                                    utcDateFormat: String = "yyyy-MM-dd",
                                    outputTimeFormat: String = "h:mm a") -> String {
        let dateFormatter = DateFormatter()
        
        // Combine date and time strings
        let utcDateTimeString = "\(utcDate)T\(utcTime):00Z"
        
        // Parse the combined date and time
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let utcDateTime = dateFormatter.date(from: utcDateTimeString) else {
            print("Failed to parse UTC date time: \(utcDateTimeString)")
            return utcTime // Return original if parsing fails
        }
        
        // Format in local time zone
        dateFormatter.dateFormat = outputTimeFormat
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: utcDateTime)
    }

    // MARK: - Convert UTC date string to local date string with time context
    /// Convert UTC date string to local date string (with time context)
    class func convertUTCDateToLocalWithTimeContext(utcDate: String,
                                    utcTime: String,
                                    utcDateFormat: String = "yyyy-MM-dd",
                                    utcTimeFormat: String = "HH:mm",
                                    outputDateFormat: String = "dd-MM-yyyy") -> String {
        let dateFormatter = DateFormatter()
        
        // Combine date and time strings
        let utcDateTimeString = "\(utcDate)T\(utcTime):00Z"
        
        // Parse the combined date and time
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let utcDateTime = dateFormatter.date(from: utcDateTimeString) else {
            print("Failed to parse UTC date time: \(utcDateTimeString)")
            return utcDate // Return original if parsing fails
        }
        
        // Format in local time zone
        dateFormatter.dateFormat = outputDateFormat
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: utcDateTime)
    }
    
    // MARK: - Backend Data Conversion Methods
    // MARK: - Convert UTC time string to local time
    class func convertUTCTimeStringToLocal(utcTimeString: String,
                                          unixTimestampMs: Int64,
                                          utcTimeFormat: String = "HH:mm:ss",
                                          outputTimeFormat: String = "h:mm a") -> String {
        // First, convert the Unix timestamp to a Date object
        let timestampDate = Date(timeIntervalSince1970: TimeInterval(unixTimestampMs / 1000))
        
        // Parse the time string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = utcTimeFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let utcTimeDate = dateFormatter.date(from: utcTimeString) else {
            print("Failed to parse UTC time: \(utcTimeString)")
            return utcTimeString
        }
        
        // Extract time components
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: utcTimeDate)
        
        // Extract date components from the Unix timestamp
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: timestampDate)
        
        // Combine them
        var fullComponents = DateComponents()
        fullComponents.year = dateComponents.year
        fullComponents.month = dateComponents.month
        fullComponents.day = dateComponents.day
        fullComponents.hour = timeComponents.hour
        fullComponents.minute = timeComponents.minute
        fullComponents.second = timeComponents.second
        
        guard let utcDateTime = calendar.date(from: fullComponents) else {
            print("Failed to create combined date time")
            return utcTimeString
        }
        
        // Convert to local time
        dateFormatter.dateFormat = outputTimeFormat
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: utcDateTime)
    }
    
    // MARK: - Get Today's Date in "yyyy-MM-dd" format
//    class func getTodaysDate() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = YYYY_MM_DD
//        let today = dateFormatter.string(from: Date())
//        return today
//    }
    
    // MARK: - Format Time Interval in Hours and Mintues
    class func formatTimeIntervalInHoursAndMintues(milliseconds: Int) -> String {
        let totalMinutes = milliseconds / (1000 * 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes) Mins"
        }
    }

}
