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
    
    let preferencesController: PreferencesController = PreferencesController()
    
    // MARK: Setup
    
    override func awakeFromNib() {
        setupStatusIcon()
        // TODO: INJECT SERVICES INSTEAD OF CREATING THEM HERE
        self.imageService = EarthImageService();
        self.wallpaperManager = WallpaperManager();
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
        guard let imageService = self.imageService, let wallpaperManager = self.wallpaperManager else {
            showAlert("missing dependencies")
            return
        }

        imageService.getImage({ result in
            switch result {
            case .Success(let url):
                wallpaperManager.setWallpaper(url, completionHandler: {
                    result in
                    switch result {
                    case .Success(_):
                        break
                    case .Error(let error):
                        self.showAlert("\(error)")
                    }
                })
            case .Error(let error):
                self.showAlert("\(error)")
            }
        })
    }
    
    @IBAction func preferencesButtonClicked(sender: NSMenuItem) {
        preferencesController.showWindow(self);
    }
    
    @IBAction func quitButtonClicked(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    // MARK: Reactions
    
    private func showAlert(text: String) {
        let alert = NSAlert()
        alert.messageText = "Error"
        alert.addButtonWithTitle("OK")
        alert.informativeText = text
        alert.runModal()
    }
}