//
//  AppController.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 03/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation
import Cocoa

class AppController: NSWindowController {
    
    var wallpaperManager: WallpaperManager?

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    @IBOutlet weak var statusMenu: NSMenu!
    
    var aboutTransitionClosure:((Void) -> Void)?
    var preferencesTransitionClosure:((Void) -> Void)?
    
    // MARK: Setup
    
    convenience init(manager: WallpaperManager) {
        self.init()
        self.wallpaperManager = manager;
    }
    
    override var windowNibName : String! {
        return "StatusMenu"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)
        
        setupStatusIcon()
    }
    
    func setupStatusIcon() {
        statusItem.menu = statusMenu
        let icon = NSImage(named: "StatusIcon")
        icon?.template = true
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    // MARK: Actions
    
    @IBAction func updateWallpaperButtonClicked(sender: NSMenuItem) {
        updateWallpaper()
    }
    
    @IBAction func preferencesButtonClicked(sender: NSMenuItem) {
        preferencesTransitionClosure?()
    }
    
    @IBAction func aboutButtonClicked(sender: NSMenuItem) {
        aboutTransitionClosure?()
    }
    
    @IBAction func quitButtonClicked(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    // MARK: Reactions
    
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
    
    private func showAlert(text: String) {
        let alert = NSAlert()
        alert.messageText = "Error"
        alert.addButtonWithTitle("OK")
        alert.informativeText = text
        alert.runModal()
    }
}