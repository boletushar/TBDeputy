//
//  ShiftInfo.swift
//  TBDeputy
//
//  Created by Tushar on 15/9/18.
//  Copyright © 2018 bole.tushar. All rights reserved.
//

import Foundation

struct ShiftInfo : Codable {
    
    let id: Int?
    
    let start: String
    let startLatitude : String
    let startLongitude : String
    
    var end : String?
    var endLatitude : String?
    var endLongitude : String?
    
    let image: String?
    
    init(startTime: String, latitude: String, longitude: String) {
        
        self.start = startTime
        self.startLatitude = latitude
        self.startLongitude = longitude
        
        self.id = 0
        self.end = nil
        self.endLatitude = nil
        self.endLongitude = nil
        
        self.image = nil
    }
    
    mutating func updateShiftEnd(endTime: String, latitude: String, longitude: String) {
        
        self.end = endTime
        self.endLatitude = latitude
        self.endLongitude = longitude
    }
    
    func getEndText() -> String {
        
        if let end = self.end, end.count > 0 {
            return "End : \(getFormattedDate(dateStr: end))"
        } else {
            return "Shift in progress"
        }
    }
    
    func getFormattedDate(dateStr: String?) -> String {
        
        if let str = dateStr, str.count > 0 {
            
            let date = Formatter.iso8601.date(from: str)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy h:mma"
            formatter.timeZone = TimeZone.init(identifier: "Australia/Melbourne")
            return formatter.string(from: date!)
            
        } else {
            return "Shift in progress"
        }
    }
}
