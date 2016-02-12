//
//  WallpaperService.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 09/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Cocoa

enum WallpaperServiceError: ErrorType {
    case NoScreensAvailableError
}

protocol WallpaperService {
    func setWallpaperImageURL(imageURL: NSURL, completionHandler: Result<Bool, ErrorType> -> Void);
}

struct WallpaperServiceImpl: WallpaperService {
    func setWallpaperImageURL(imageURL: NSURL, completionHandler: Result<Bool, ErrorType> -> Void) {
        let workspace = NSWorkspace.sharedWorkspace()
        
        guard let screens = NSScreen.screens() else {
            completionHandler(Result.Error(WallpaperServiceError.NoScreensAvailableError))
            return
        }
        
        // For screens we mean monitors. There is no way to access other desktops. 
        // One way would be to change the background when the user switches desktop, but for now we keep it simple.
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