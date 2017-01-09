//
//  Request.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 25/11/2016.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameter: [String: AnyObject] { get }
    
    associatedtype Response: Decodable
}

extension Request {
    var method: HTTPMethod {
        return .GET
    }
    var parameter: [String: AnyObject] {
        return [:]
    }
}



