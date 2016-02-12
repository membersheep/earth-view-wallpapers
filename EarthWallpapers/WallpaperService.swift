//
//  WallpaperService.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 09/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Cocoa

protocol WallpaperService {
    func setWallpaperImageURL(imageURL: NSURL, completionHandler: Result<Bool, ErrorType> -> Void);
}

struct WallpaperServiceImpl: WallpaperService {
    func setWallpaperImageURL(imageURL: NSURL, completionHandler: Result<Bool, ErrorType> -> Void) {
        let workspace = NSWorkspace.sharedWorkspace()
        guard let screens = NSScreen.screens() else {
            completionHandler(Result.Error(WallpaperManagerError.NoScreensAvailableError))
            return
        }
        
        _ = screens.map({
            screen in
            do {
                try workspace.setDesktopImageURL(imageURL, forScreen: screen, options: workspace.desktopImageOptionsForScreen(screen)!)
            } catch {
                completionHandler(Result.Error(error))
                return
            }
        })
        
        completionHandler(Result.Success(true))
    }
}