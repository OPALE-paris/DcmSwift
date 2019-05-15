//
//  Logger.swift
//  DcmSwift
//
//  Created by paul on 15/05/2019.
//  Copyright © 2019 Read-Write.fr. All rights reserved.
//

import Foundation

public class Logger {

    public enum LogLevel : String {
        case Notice  = "NOTICE"
        case Info    = "INFO"
        case Verbose = "VERBOSE"
        case Debug   = "DEBUG"
        case Warning = "WARNING"
        case Error   = "ERROR"
    }

    public enum Output {
        case Stdout
        case File
    }

    public var fileName:String = "/"
    public var outputs:[Output] = [.Stdout]

    private static var shared = Logger()

    public static func info(_ string:String, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        shared.output(string: string, file, function, line: line, severity: LogLevel.Info)
    }

    public static func warning(string:String, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        shared.output(string: string, file, function, line: line, severity: LogLevel.Warning)
    }

    public static func error(string:String, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        shared.output(string: string, file, function, line: line, severity: LogLevel.Error)
    }

    public static func notice(string:String, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        shared.output(string: string, file, function, line: line, severity: LogLevel.Notice)
    }

    public static func verbose(string:String, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        shared.output(string: string, file, function, line: line, severity: LogLevel.Notice)
    }

    public static func debug(string:String, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        shared.output(string: string, file, function, line: line, severity: LogLevel.Debug)
    }

    public func output(string:String, _ file: String = #file, _ function: String = #function, line: Int = #line, severity:LogLevel) {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let outputString:String = "\(df.string(from: date)) \(severity.rawValue) \t -> \(string)"

        for output in outputs {
            switch output {
            case .Stdout:
                consoleLog(message: outputString)
            case .File:
                fileLog(message: outputString)
            }

        }
    }

    public func consoleLog(message:String) {
        print(message)
    }

    public func fileLog(message: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)

            FileManager.default.createFile(atPath: fileURL.path, contents: Data(), attributes: nil)

            //writing
            do {
                print("J ECRIS : \(fileURL)")
                try message.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
    }



    public static func setDestinations(_ destinations: [Output], filePath: String = "/") {
        shared.outputs = destinations
        shared.fileName = filePath
    }
}
