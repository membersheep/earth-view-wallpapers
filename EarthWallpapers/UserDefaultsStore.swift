//
//  UserDefaultsStore.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 10/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

protocol UserDefaultsStore {
    func setStartAtLogin(value: Bool)
    func getStartAtLogin() -> Bool
    func setUpdateInterval(value: Double)
    func getUpdateInterval() ->  Double
    func setLastUpdateDate(date: NSDate?)
    func getLastUpdateDate() -> NSDate?
}

struct UserDefaultsStoreImpl: UserDefaultsStore {
    
    private let STARTUP_DEFAULTS_KEY = "STARTUP_KEY"
    private let INTERVAL_DEFAULTS_KEY = "INTERVAL_DEFAULTS_KEY"
    private let LAST_UPDATE_DEFAULTS_KEY = "LAST_UPDATE_DEFAULTS_KEY"
    
    func setStartAtLogin(value: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: STARTUP_DEFAULTS_KEY)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getStartAtLogin() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(STARTUP_DEFAULTS_KEY)
    }
    
    func setUpdateInterval(value: Double) {
        NSUserDefaults.standardUserDefaults().setDouble(value, forKey: INTERVAL_DEFAULTS_KEY)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getUpdateInterval() ->  Double {
        return NSUserDefaults.standardUserDefaults().doubleForKey(INTERVAL_DEFAULTS_KEY)
    }
    
    func setLastUpdateDate(date: NSDate?) {
        guard let newDate = date else {
            return
        }
        NSUserDefaults.standardUserDefaults().setObject(newDate, forKey: LAST_UPDATE_DEFAULTS_KEY)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getLastUpdateDate() -> NSDate? {
        return NSUserDefaults.standardUserDefaults().objectForKey(LAST_UPDATE_DEFAULTS_KEY) as? NSDate
    }
}