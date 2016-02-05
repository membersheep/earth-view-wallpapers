//
//  PreferencesController.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 05/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation
import Cocoa

enum TimeInterval: String {
    case Hour = "Hour"
    case Day = "Day"
    case Week = "Week"
}

let TIME_KEY = "timeInterval";
let STARTUP_KEY = "startup";

class PreferencesController: NSWindowController, NSWindowDelegate, NSComboBoxDelegate {
    
    @IBOutlet weak var startupCheckBox: NSButton!
    @IBOutlet weak var timeComboBox: NSComboBox!
    
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
        let timeIntervalString = NSUserDefaults.standardUserDefaults().stringForKey(TIME_KEY) ?? TimeInterval.Hour.rawValue
        let startupActive = NSUserDefaults.standardUserDefaults().boolForKey(STARTUP_KEY)

        self.startupCheckBox.state = startupActive ? NSOnState : NSOffState
        self.timeComboBox.selectItemWithObjectValue(timeIntervalString)
    }
    
    // MARK: NSButton action
    
    @IBAction func checkBoxClicked(sender: NSButton) {
        if sender.state == NSOnState {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: STARTUP_KEY)
        } else {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: STARTUP_KEY)
        }
    }
    
    // MARK: NSComboBoxDelegate
    
    func comboBoxSelectionDidChange(notification: NSNotification) {
        guard let selectedValue = notification.object?.objectValueOfSelectedItem as? String else {
            return
        }
        guard let timeInterval = TimeInterval(rawValue: selectedValue) else {
            return
        }
        
        switch timeInterval {
        case TimeInterval.Hour:
            NSUserDefaults.standardUserDefaults().setDouble(3600.0, forKey: "savedTimeInterval")
        case TimeInterval.Day:
            NSUserDefaults.standardUserDefaults().setDouble(3600.0*24, forKey: "savedTimeInterval")
        case TimeInterval.Week:
            NSUserDefaults.standardUserDefaults().setDouble(3600.0*24*7, forKey: "savedTimeInterval")
        }
        NSUserDefaults.standardUserDefaults().setObject(selectedValue, forKey: TIME_KEY)
    }
}