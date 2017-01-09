//
//  Decodable.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 25/11/2016.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

protocol Decodable {
    static func parse(data: Data) -> Self?
}
