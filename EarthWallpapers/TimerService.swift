//
//  TimerService.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 12/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

protocol Timer {
    func start(_ lastTriggerDate: Date, interval: Foundation.TimeInterval, triggerFunction: (Void) -> Void)
    func stop()
}

class TimerService: NSObject, Timer {
    
    fileprivate var timer: Foundation.Timer?
    fileprivate var triggeredClosure:(Void)->Void = {}
    
    func start(_ lastTriggerDate: Date, interval: Foundation.TimeInterval, triggerFunction: @escaping (Void) -> Void) {
        self.triggeredClosure = triggerFunction
        let fireDate = Date(timeInterval: interval, since: lastTriggerDate)
        
        timer = Foundation.Timer(fireAt: fireDate, interval: interval, target: self, selector: #selector(TimerService.trigger), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    func trigger() {
        triggeredClosure();
    }
    
    func stop() {
        timer?.invalidate()
    }
}
