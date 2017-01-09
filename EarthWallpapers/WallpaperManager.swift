//
//  WallpaperManager.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 04/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation
import AppKit

protocol WallpaperManager {
    func changeWallpaper(_ completionHandler: (Result<Bool, Error>) -> Void)
}

class WallpaperManagerImpl: WallpaperManager, PreferencesDelegate {
    
    fileprivate var wallpaperService: WallpaperService
    fileprivate var downloadService: ImageDownloadService
    fileprivate var timer: Timer
    fileprivate var userDefaultsManager: UserDefaultsStore
    
    init(wallpaperService: WallpaperService, downloadService: ImageDownloadService, timer: Timer, userDefaultsManager: UserDefaultsStore) {
        self.wallpaperService = wallpaperService
        self.downloadService = downloadService
        self.userDefaultsManager = userDefaultsManager
        self.timer = timer
        
        if (isAutoUpdateActive()) {
            enableAutoWallpaperUpdate()
        }
    }
    
    fileprivate func isAutoUpdateActive() -> Bool {
        guard let _ = userDefaultsManager.getLastUpdateDate() else {
            return false
        }
        if userDefaultsManager.getUpdateInterval() == 0.0 {
            return false
        }
        return true
    }
    
    func changeWallpaper(_ completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        downloadService.getImage({
            result in
            switch result {
                case .success(let imageUrl):
                    self.wallpaperService.setWallpaperImageURL(imageUrl, completionHandler: {
                        result in
                        switch result {
                        case .success(let success):
                            self.userDefaultsManager.setLastUpdateDate(Date())
                            completionHandler(Result.success(success))
                        case .error(let error):
                            completionHandler(Result.error(error))
                        }
                    })
                case .error(let error):
                completionHandler(Result.error(error))
            }
        })
    }
    
    func enableAutoWallpaperUpdate() {
        let lastUpdateDate = userDefaultsManager.getLastUpdateDate()
        let interval = userDefaultsManager.getUpdateInterval()
        
        timer.start(lastUpdateDate!, interval: interval, triggerFunction: {
            self.changeWallpaper({_ in })
        })
    }
    
    func disableAutoWallpaperUpdate() {
        timer.stop()
    }
    
    // MARK: PreferencesDelegate
    
    func timeIntervalUpdated(_ interval: Foundation.TimeInterval) {
        disableAutoWallpaperUpdate()
        userDefaultsManager.setLastUpdateDate(Date())
        if (interval > 0.0) {
            enableAutoWallpaperUpdate()
        }
    }

}
