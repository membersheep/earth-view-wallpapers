//
//  RequestSender.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 25/11/2016.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

protocol RequestSender {
    var host: String { get }
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void)
}

