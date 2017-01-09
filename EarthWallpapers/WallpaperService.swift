//
//  WallpaperService.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 09/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Cocoa

enum WallpaperServiceError: Error {
    case noScreensAvailableError
}

protocol WallpaperService {
    func setWallpaperImageURL(_ imageURL: URL, completionHandler: (Result<Bool, Error>) -> Void);
}

struct WallpaperServiceImpl: WallpaperService {
    func setWallpaperImageURL(_ imageURL: URL, completionHandler: (Result<Bool, Error>) -> Void) {
        let workspace = NSWorkspace.shared()
        
        guard let screens = NSScreen.screens() else {
            completionHandler(Result.error(WallpaperServiceError.noScreensAvailableError))
            return
        }
        
        // For screens we mean monitors. There is no way to access other desktops. 
        // One way would be to change the background when the user switches desktop, but for now we keep it simple.
        _ = screens.map({
            screen in
            do {
                try workspace.setDesktopImageURL(imageURL, for: screen, options: workspace.desktopImageOptions(for: screen)!)
            } catch {
                completionHandler(Result.error(error))
                return
            }
        })
        
        completionHandler(Result.success(true))
    }
}
