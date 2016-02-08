//
//  TimerService.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 05/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

class TimerService: NSObject, TimerProtocol {
    
    private var timer: NSTimer?
    private var triggeredClosure:(Void)->Void = {}
    
    func start(lastTriggerDate: NSDate, interval: NSTimeInterval, triggerFunction: Void -> Void) {
        self.triggeredClosure = triggerFunction
        let fireDate = NSDate(timeInterval: interval, sinceDate: lastTriggerDate)
        
        timer = NSTimer(fireDate: fireDate, interval: interval, target: self, selector: Selector("trigger"), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    func trigger() {
        triggeredClosure();
    }

    func stop() {
        timer?.invalidate()
    }
}