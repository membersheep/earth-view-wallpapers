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
    
    var wallpaperManager: WallpaperManager?
    
    // MARK: Setup
    
    override func awakeFromNib() {
        setupStatusIcon()
    }
    
    init(manager: WallpaperManager) {
        self.wallpaperManager = manager;
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
        updateWallpaper()
    }
    
    private func updateWallpaper() {
        guard let wallpaperManager = self.wallpaperManager else {
            showAlert("missing dependencies")
            return
        }
        wallpaperManager.changeWallpaper({
            result in
            switch(result){
            case .Success:
                break
            case .Error(let error):
                self.showAlert("\(error)")
                break
            }
        })
    }
    
    // TODO: To be implemented
    @IBAction func preferencesButtonClicked(sender: NSMenuItem) {
        
    }
    
    // TODO: To be implemented
    @IBAction func aboutButtonClicked(sender: NSMenuItem) {
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