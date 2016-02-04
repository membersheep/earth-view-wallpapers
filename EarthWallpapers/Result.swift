//
//  Result.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 03/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

enum Result<T> {
    case Error(ErrorType)
    case Success(T)
}