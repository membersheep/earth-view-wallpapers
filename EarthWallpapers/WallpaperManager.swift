//
//  WallpaperManager.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 04/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation
import AppKit

class WallpaperManager: WallpaperManagerProtocol {
    
    func setWallpaper(path: NSURL, completionHandler: Result<Bool> -> Void) {
        let workspace = NSWorkspace.sharedWorkspace()
        for screen in NSScreen.screens()! {
            do {
                try workspace.setDesktopImageURL(path, forScreen: screen, options: workspace.desktopImageOptionsForScreen(screen)!)
            } catch {
                print("error setting the screen")
            }
        }
        
    }

}