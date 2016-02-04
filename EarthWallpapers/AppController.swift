//
//  AppController.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 03/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation
import Cocoa

class AppController: NSObject {

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    @IBOutlet weak var statusMenu: NSMenu!
    
    var imageService: ImageServiceProtocol?
    var wallpaperManager: WallpaperManagerProtocol?
    
    // MARK: Setup
    
    override func awakeFromNib() {
        setupStatusIcon()
        self.imageService = EarthImageService();
    }
    
    func setDependencies(imageService: ImageServiceProtocol, wallpaperManager: WallpaperManagerProtocol) {
        self.imageService = imageService
        self.wallpaperManager = wallpaperManager
    }
    
    func setupStatusIcon() {
        statusItem.menu = statusMenu
        let icon = NSImage(named: "StatusIcon")
        icon?.template = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    // MARK: Actions
    
    @IBAction func updateWallpaperButtonClicked(sender: NSMenuItem) {
        guard let imageService = self.imageService else {
            // TODO: THROW ERROR MESSAGE (alert or something)
            print("dependency missing")
            return
        }

        imageService.getImage({ result in
            switch result {
            case .Success(let url):
                print(url)
//                wallpaperManager.setWallpaper(url, completionHandler: {
//                    (result: Result<Bool>) -> Void in
//                    switch result {
//                    case .Success(let success):
//                        // TODO: Display success notification
//                        print(success)
//                    case .Error(let error):
//                        // TODO: Display error notification
//                        print(error)
//                    }
//                })
            case .Error(let error):
                print(error)
            }
        })
    }
    
    @IBAction func preferencesButtonClicked(sender: NSMenuItem) {
//        preferencesWindow.showWindow(nil)
    }
    
    @IBAction func quitButtonClicked(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
}