//
//  TimerProtocol.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 05/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Cocoa

protocol TimerProtocol {
    mutating func start(lastTriggerDate: NSDate, interval: NSTimeInterval, triggerFunction: Void -> Void)
    func stop()
}