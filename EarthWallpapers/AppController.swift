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

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
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
        NSApp.activate(ignoringOtherApps: true)
        
        setupStatusIcon()
    }
    
    func setupStatusIcon() {
        statusItem.menu = statusMenu
        let icon = NSImage(named: "StatusIcon")
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    // MARK: Actions
    
    @IBAction func updateWallpaperButtonClicked(_ sender: NSMenuItem) {
        updateWallpaper()
    }
    
    @IBAction func preferencesButtonClicked(_ sender: NSMenuItem) {
        preferencesTransitionClosure?()
    }
    
    @IBAction func aboutButtonClicked(_ sender: NSMenuItem) {
        aboutTransitionClosure?()
    }
    
    @IBAction func quitButtonClicked(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
    
    // MARK: Reactions
    
    fileprivate func updateWallpaper() {
        guard let wallpaperManager = self.wallpaperManager else {
            showAlert("missing dependencies")
            return
        }
        wallpaperManager.changeWallpaper({
            result in
            switch(result){
            case .success:
                break
            case .error(let error):
                self.showAlert("\(error)")
                break
            }
        })
    }
    
    fileprivate func showAlert(_ text: String) {
        let alert = NSAlert()
        alert.messageText = "Error"
        alert.addButton(withTitle: "OK")
        alert.informativeText = text
        alert.runModal()
    }
}
