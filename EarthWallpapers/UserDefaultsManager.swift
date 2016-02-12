//
//  UserDefaultsManager.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 10/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

protocol UserDefaultsManager {
    func setStartAtLogin(value: Bool)
    func getStartAtLogin() -> Bool
    func setUpdateInterval(value: Double)
    func getUpdateInterval() ->  Double
    func setLastUpdateDate(date: NSDate?)
    func getLastUpdateDate() -> NSDate?
}

