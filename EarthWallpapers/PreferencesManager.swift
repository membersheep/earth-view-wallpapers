//
//  PreferencesManager.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 08/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

protocol PreferencesManager {
    func getStartAtLogin() -> Bool
    func setStartAtLogin(_ value: Bool)
    func getUpdateInterval() -> TimeInterval
    func setUpdateInterval(_ interval: TimeInterval)
    
    var delegate: PreferencesDelegate? {get set}
}

protocol PreferencesDelegate {
    func timeIntervalUpdated(_ interval: Foundation.TimeInterval)
}

enum TimeInterval: String {
    case Never = "Never"
    case Hour = "Hour"
    case Day = "Day"
    case Week = "Week"
}

class PreferencesManagerImpl: PreferencesManager {
    
    fileprivate var startupService: StartupService
    fileprivate var userDefaultsManager: UserDefaultsStore
    
    var delegate: PreferencesDelegate?
    
    init(startupService: StartupService, userDefaultsManager: UserDefaultsStore) {
        self.startupService = startupService
        self.userDefaultsManager = userDefaultsManager
    }
    
    func getStartAtLogin() -> Bool {
        return startupService.applicationIsInStartUpItems()
    }
    
    func setStartAtLogin(_ value: Bool) {
        if (value) {
            startupService.addApplicationToStartupItems()
        } else {
            startupService.removeApplicationFromStartupItems()
        }
    }

    func getUpdateInterval() -> TimeInterval {
        switch (userDefaultsManager.getUpdateInterval()) {
        case 0.0:
            return .Never
        case 10.0:
            return .Hour
        case 3600.0 * 24:
            return .Day
        case 3600.0 * 24 * 7:
            return .Week
        default:
            return .Never
        }
    }

    func setUpdateInterval(_ interval: TimeInterval) {
        var intervalInSeconds: Double = 0;
        switch (interval) {
        case .Never:
            intervalInSeconds = 0.0
            break
        case .Hour:
            intervalInSeconds = 10.0
            break
        case .Day:
            intervalInSeconds = 3600.0 * 24
            break
        case .Week:
            intervalInSeconds = 3600.0 * 24 * 7
            break
        }
        userDefaultsManager.setUpdateInterval(intervalInSeconds)
        
        delegate?.timeIntervalUpdated(intervalInSeconds)
    }
}
