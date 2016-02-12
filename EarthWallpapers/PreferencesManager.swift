//
//  PreferencesManager.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 08/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

protocol Preferences {
    func getStartAtLogin() -> Bool
    func setStartAtLogin(value: Bool)
    func getUpdateInterval() -> TimeInterval
    mutating func setUpdateInterval(interval: TimeInterval)
}

enum TimeInterval: String {
    case Hour = "Hour"
    case Day = "Day"
    case Week = "Week"
}

struct PreferencesManager: Preferences {
    
    private var startupService: StartupService
    private var timerService: TimerService
    private var userDefaultsManager: UserDefaultsManager
    
    init(startupService: StartupService, timerService: TimerService, userDefaultsManager: UserDefaultsManager) {
        self.startupService = startupService
        self.timerService = timerService
        self.userDefaultsManager = userDefaultsManager
    }
    
    func getStartAtLogin() -> Bool {
        return startupService.applicationIsInStartUpItems()
    }
    
    func setStartAtLogin(value: Bool) {
        if (value) {
            startupService.addApplicationToStartupItems()
        } else {
            startupService.removeApplicationFromStartupItems()
        }
    }

    func getUpdateInterval() -> TimeInterval {
        switch (userDefaultsManager.getUpdateInterval()) {
        case 3600.0:
            return .Hour
        case 3600.0 * 24:
            return .Day
        case 3600.0 * 24 * 7:
            return .Week
        default:
            return .Hour
        }
    }

    mutating func setUpdateInterval(interval: TimeInterval) {
        var intervalInSeconds: Double = 0;
        switch (interval) {
        case .Hour:
            intervalInSeconds = 3600.0
            break
        case .Day:
            intervalInSeconds = 3600.0 * 24
            break
        case .Week:
            intervalInSeconds = 3600.0 * 24 * 7
            break
        }
        userDefaultsManager.setUpdateInterval(intervalInSeconds)
        
        guard let lastUpdateDate = userDefaultsManager.getLastUpdateDate() else {
            return
        }
        // TODO: Set lastupdatedate and interval in timer
        timerService.start(lastUpdateDate, interval: intervalInSeconds, triggerFunction: {})
    }
}