//
//  SwiftLog.swift
//  Common
//
//  Created by GREEN on 6/14/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public class SwiftLog {
  public static let logger: SwiftLog = SwiftLog()
  
  public let maxFileSize: UInt64
  public let maxFileCount: Int
  public let printToConsole: Bool
  public var directory = SwiftLog.defaultDirectory() {
    didSet {
      directory = NSString(string: directory).expandingTildeInPath
      
      let fileManager = FileManager.default
      if !fileManager.fileExists(atPath: directory) {
        do {
          try fileManager.createDirectory(
            atPath: directory,
            withIntermediateDirectories: true,
            attributes: nil
          )
        } catch {
          NSLog("Couldn't create directory at \(directory)")
        }
      }
    }
  }
  public var currentPath: String {
    return "\(directory)/\(logName(0))"
  }
  private let name = "logfile"
  
  public init(
    maxFileSize: UInt64 = 10240,
    maxFileCount: Int = 8,
    printToConsole: Bool = false
  ) {
    self.maxFileSize = maxFileSize
    self.maxFileCount = maxFileCount
    self.printToConsole = printToConsole
  }
  
  public func write(_ text: String) {
    let path = currentPath
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: path) {
      do {
        try "".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
      } catch _ {
      }
    }
    if let fileHandle = FileHandle(forWritingAtPath: path) {
      let writeText = "[\(text)\n"
      fileHandle.seekToEndOfFile()
      // swiftlint:disable force_unwrapping
      fileHandle.write(writeText.data(using: String.Encoding.utf8)!)
      // swiftlint:enable force_unwrapping
      fileHandle.closeFile()
      if printToConsole {
        print(writeText, terminator: "")
      }
      cleanup()
    }
  }
  
  private func cleanup() {
    let path = "\(directory)/\(logName(0))"
    let size = fileSize(path)
    let maxSize: UInt64 = maxFileSize * 1024
    if size > 0
        && size >= maxSize
        && maxSize > 0
        && maxFileCount > 0 {
      rename(0)
      
      let deletePath = "\(directory)/\(logName(maxFileCount))"
      let fileManager = FileManager.default
      do {
        try fileManager.removeItem(atPath: deletePath)
      } catch _ {
      }
    }
  }
  
  private func fileSize(_ path: String) -> UInt64 {
    let fileManager = FileManager.default
    let attrs: NSDictionary? = try? fileManager.attributesOfItem(atPath: path) as NSDictionary
    if let dict = attrs {
      return dict.fileSize()
    }
    return 0
  }
  
  private func rename(_ index: Int) {
    let fileManager = FileManager.default
    let path = "\(directory)/\(logName(index))"
    let newPath = "\(directory)/\(logName(index + 1))"
    if fileManager.fileExists(atPath: newPath) {
      rename(index + 1)
    }
    do {
      try fileManager.moveItem(atPath: path, toPath: newPath)
    } catch _ {
    }
  }
  
  private func logName(_ num: Int) -> String {
    return "\(name)-\(num).log"
  }
  
  static func defaultDirectory() -> String {
    var path = ""
    let fileManager = FileManager.default
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    path = "\(paths[0])/Logs"
    
    if !fileManager.fileExists(atPath: path) && !(path.isEmpty)  {
      do {
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
      } catch _ {
      }
    }
    return path
  }
}
