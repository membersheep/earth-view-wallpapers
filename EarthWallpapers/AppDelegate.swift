//
//  AppDelegate.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 04/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    var appController: AppController?
    var preferencesController: PreferencesController?
    var aboutController: AboutController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Create and wire modules
        // TODO: Move to a dedicated factory class/struct
        let wallpaperService: WallpaperService = WallpaperServiceImpl()
        let imageService: ImageDownloadService = EarthImageService()
        let startupService: StartupService = StartupServiceImpl()
        let timer: Timer = TimerService()
        let defaultsManager: UserDefaultsStore = UserDefaultsStoreImpl()
        
        let preferencesManager = PreferencesManagerImpl(startupService: startupService, userDefaultsManager: defaultsManager)
        let wallpaperManager = WallpaperManagerImpl(wallpaperService: wallpaperService, downloadService: imageService, timer: timer, userDefaultsManager: defaultsManager)
        preferencesManager.delegate = wallpaperManager
        
        appController = AppController(manager: wallpaperManager)
        appController?.preferencesTransitionClosure = {
            self.preferencesController = PreferencesController(manager: preferencesManager)
            self.preferencesController?.showWindow(self)
        }
        appController?.aboutTransitionClosure = {
            self.aboutController = AboutController()
            self.aboutController?.showWindow(self)
        }
        
        appController?.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

