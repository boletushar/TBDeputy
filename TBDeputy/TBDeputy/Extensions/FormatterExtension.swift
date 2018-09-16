//
//  FormatterExtension.swift
//  TBDeputy
//
//  Created by Tushar on 15/9/18.
//  Copyright © 2018 bole.tushar. All rights reserved.
//

import Foundation

extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.formatOptions = [.withInternetDateTime, .withColonSeparatorInTimeZone]
        return formatter
    }()
}
