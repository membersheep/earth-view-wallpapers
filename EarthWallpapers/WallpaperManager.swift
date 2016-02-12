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
    func changeWallpaper(completionHandler: Result<Bool, ErrorType> -> Void)
}

struct WallpaperManagerImpl: WallpaperManager, PreferencesDelegate {
    
    private var wallpaperService: WallpaperService
    private var downloadService: ImageDownloadService
    private var timer: Timer
    private var userDefaultsManager: UserDefaultsManager
    
    init(wallpaperService: WallpaperService, downloadService: ImageDownloadService, timer: Timer, userDefaultsManager: UserDefaultsManager) {
        self.wallpaperService = wallpaperService
        self.downloadService = downloadService
        self.userDefaultsManager = userDefaultsManager
        self.timer = timer
    }
    
    func changeWallpaper(completionHandler: Result<Bool, ErrorType> -> Void) {
        downloadService.getImage({
            result in
            switch result {
                case .Success(let imageUrl):
                    self.wallpaperService.setWallpaperImageURL(imageUrl, completionHandler: {
                        result in
                        switch result {
                        case .Success(let success):
                            // TODO: save last update date
                            completionHandler(Result.Success(success))
                        case .Error(let error):
                            completionHandler(Result.Error(error))
                        }
                    })
                case .Error(let error):
                completionHandler(Result.Error(error))
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
    
    func timeIntervalUpdated(interval: NSTimeInterval) {
        disableAutoWallpaperUpdate()
        userDefaultsManager.setLastUpdateDate(NSDate())
        enableAutoWallpaperUpdate()
    }

}