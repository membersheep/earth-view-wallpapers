//
//  WallpaperManager.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 04/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation
import AppKit

struct WallpaperManager: WallpaperManagerProtocol {
    
    internal func setWallpaper(path: NSURL, completionHandler: Result<Bool, ErrorType> -> Void) {
        let workspace = NSWorkspace.sharedWorkspace()
        guard let screens = NSScreen.screens() else {
            completionHandler(Result.Error(WallpaperManagerError.NoScreensAvailableError))
            return
        }
        
        _ = screens.map({
            screen in
            do {
                try workspace.setDesktopImageURL(path, forScreen: screen, options: workspace.desktopImageOptionsForScreen(screen)!)
            } catch {
                completionHandler(Result.Error(error))
                return
            }
        })
        
        completionHandler(Result.Success(true))
    }

}