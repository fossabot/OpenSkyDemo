//
//  Logger.swift
//  OpenSkyDemo
//
//  Created by Ferdinand Urban on 16.03.2022.
//

import Foundation

enum LogEvent: String {
  case error = "[ERROR]"
  case info = "[INFO]"
  case debug = "[DEBUG]"
  case warning = "[WARN]"
}

func print(_ object: Any) {
#if DEBUG
  Swift.print(object)
#endif
}

class Logger {
 
  static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
  static var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone.current
    return formatter
  }
  
  private static var isLoggingEnabled: Bool {
#if DEBUG
    return true
#else
    return false
#endif
  }
  
  // MARK: - Loging methods

  class func error( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    if isLoggingEnabled {
      print("\(Date().toString()) \(LogEvent.error.rawValue)[\(sourceFileName(filePath: filename))]@\(line)[\(funcName)]: \(object)")
    }
  }
  
  class func info( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    if isLoggingEnabled {
      print("\(Date().toString()) \(LogEvent.info.rawValue)[\(sourceFileName(filePath: filename))]@\(line)[\(funcName)]: \(object)")
    }
  }
  
  class func debug( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    if isLoggingEnabled {
      print("\(Date().toString()) \(LogEvent.debug.rawValue)[\(sourceFileName(filePath: filename))]@\(line)[\(funcName)]: \(object)")
    }
  }
  
  class func warning( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    if isLoggingEnabled {
      print("\(Date().toString()) \(LogEvent.warning.rawValue)[\(sourceFileName(filePath: filename))]@\(line)[\(funcName)]: \(object)")
    }
  }
  
  private class func sourceFileName(filePath: String) -> String {
    let components = filePath.components(separatedBy: "/")
    return components.isEmpty ? "" : components.last!
  }
}

internal extension Date {
  func toString() -> String {
    return Logger.dateFormatter.string(from: self as Date)
  }
}
