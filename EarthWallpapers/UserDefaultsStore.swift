//
//  UserDefaultsStore.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 10/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

protocol UserDefaultsStore {
    func setStartAtLogin(_ value: Bool)
    func getStartAtLogin() -> Bool
    func setUpdateInterval(_ value: Double)
    func getUpdateInterval() ->  Double
    func setLastUpdateDate(_ date: Date?)
    func getLastUpdateDate() -> Date?
}

struct UserDefaultsStoreImpl: UserDefaultsStore {
    
    fileprivate let STARTUP_DEFAULTS_KEY = "STARTUP_KEY"
    fileprivate let INTERVAL_DEFAULTS_KEY = "INTERVAL_DEFAULTS_KEY"
    fileprivate let LAST_UPDATE_DEFAULTS_KEY = "LAST_UPDATE_DEFAULTS_KEY"
    
    func setStartAtLogin(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: STARTUP_DEFAULTS_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func getStartAtLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: STARTUP_DEFAULTS_KEY)
    }
    
    func setUpdateInterval(_ value: Double) {
        UserDefaults.standard.set(value, forKey: INTERVAL_DEFAULTS_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func getUpdateInterval() ->  Double {
        return UserDefaults.standard.double(forKey: INTERVAL_DEFAULTS_KEY)
    }
    
    func setLastUpdateDate(_ date: Date?) {
        guard let newDate = date else {
            return
        }
        UserDefaults.standard.set(newDate, forKey: LAST_UPDATE_DEFAULTS_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func getLastUpdateDate() -> Date? {
        return UserDefaults.standard.object(forKey: LAST_UPDATE_DEFAULTS_KEY) as? Date
    }
}
