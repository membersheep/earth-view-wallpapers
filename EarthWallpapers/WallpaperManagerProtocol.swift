//
//  WallpaperManagerProtocol.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 03/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

enum WallpaperManagerError: ErrorType {
    case NoScreensAvailableError
}

protocol WallpaperManagerProtocol {
    func setWallpaper(path: NSURL, completionHandler: Result<Bool, ErrorType> -> Void)
}