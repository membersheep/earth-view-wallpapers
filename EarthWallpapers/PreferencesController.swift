//
//  PreferencesController.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 05/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation
import Cocoa

class PreferencesController: NSWindowController, NSWindowDelegate, NSComboBoxDelegate {
    
    var preferencesManager: PreferencesManager?
    
    @IBOutlet weak var startupCheckBox: NSButton!
    @IBOutlet weak var timeComboBox: NSComboBox!
    
    convenience init(manager: PreferencesManager) {
        self.init()
        self.preferencesManager = manager;
    }
    
    override var windowNibName : String! {
        return "PreferencesWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)
        
        loadPreferences()
    }
    
    private func loadPreferences() {
        guard let prefs = preferencesManager else {
            return
        }
        self.timeComboBox.selectItemWithObjectValue(prefs.getUpdateInterval().rawValue)
        self.startupCheckBox.state = prefs.getStartAtLogin() ? NSOnState : NSOffState
    }
    
    // MARK: NSButton action
    
    @IBAction func checkBoxClicked(sender: NSButton) {
        let state: Bool = sender.state == NSOnState ? true : false
        preferencesManager?.setStartAtLogin(state)
    }
    
    // MARK: NSComboBoxDelegate
    
    func comboBoxSelectionDidChange(notification: NSNotification) {
        guard let selectedValue = notification.object?.objectValueOfSelectedItem as? String else {
            return
        }
        guard let timeInterval = TimeInterval(rawValue: selectedValue) else {
            return
        }
        preferencesManager?.setUpdateInterval(timeInterval)
    }
}