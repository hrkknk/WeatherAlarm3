//
//  Alerm.swift
//  WeatherAlerm
//
//  Created by 金子宏樹 on 2018/10/06.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit
import os.log

class Alerm: NSObject, NSCoding {
    
    //MARK: - Properties
    
    var sunnyAlermTime: Date
    var rainyAlermTime: Date

    //MARK: - Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("alerm")
    
    
    //MARK: - Types
    
    struct PropertyKey {
        static let sunnyAlermTime = "sunnyAlermTime"
        static let rainyAlermTime = "rainyAlermTime"
    }
    
    
    //MARK: Initialization
    
    init?(sunnyAlermTime: Date, rainyAlermTime: Date) {
        
        // Initialize stored properties.
        self.sunnyAlermTime = sunnyAlermTime
        self.rainyAlermTime = rainyAlermTime
    }
    
    //MARK: - Public methods
    public func getSunnyAlarmTimeAsString() -> String {
        // 日付のフォーマッタ
        let dateFormatter = DateFormatter()
        // 日付の出力形式を決める
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        // TODO: localeはあとで変更
        dateFormatter.locale = Locale(identifier: "ja_JP")

        return dateFormatter.string(from: sunnyAlermTime)
    }
    
    func getRainyAlarmTimeAsString() -> String {
        // 日付のフォーマッタ
        let dateFormatter = DateFormatter()
        // 日付の出力形式を決める
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        // TODO: localeはあとで変更
        dateFormatter.locale = Locale(identifier: "ja_JP")
        
        return dateFormatter.string(from: rainyAlermTime)
    }
    
    
    //MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(sunnyAlermTime, forKey: PropertyKey.sunnyAlermTime)
        aCoder.encode(rainyAlermTime, forKey: PropertyKey.rainyAlermTime)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let sunnyAlermTime = aDecoder.decodeObject(forKey: PropertyKey.sunnyAlermTime) as? Date else {
            os_log("Unable to decode the time for a Alerm object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let rainyAlermTime = aDecoder.decodeObject(forKey: PropertyKey.rainyAlermTime) as? Date else {
            os_log("Unable to decode the time for a Alerm object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(sunnyAlermTime: sunnyAlermTime, rainyAlermTime: rainyAlermTime)
    }
    
}
