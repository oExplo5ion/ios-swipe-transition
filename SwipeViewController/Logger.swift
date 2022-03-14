//
//  Logger.swift
//  SwipeViewController
//
//  Created by Aleksey on 11.03.2022.
//

import Foundation

struct Logger {
    static func log(message: String = "", function: String = #function, line: Int = #line) {
        print("log: \(message)\nfunction: \(function)\nline: \(line)")
    }
}
