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

enum WallpaperManagerError: ErrorType {
    case NoScreensAvailableError
}

struct WallpaperManagerImpl: WallpaperManager {
    
    private var wallpaperService: WallpaperService
    private var downloadService: ImageDownloadService
    
    init(wallpaperService: WallpaperService, downloadService: ImageDownloadService) {
        self.wallpaperService = wallpaperService
        self.downloadService = downloadService
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

}