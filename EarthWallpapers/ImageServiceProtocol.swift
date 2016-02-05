//
//  ImageServiceProtocol.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 03/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

enum ImageServiceError: ErrorType {
    case GenericError
}

protocol ImageServiceProtocol {
    func getImage(completionHandler: Result<NSURL, ImageServiceError> -> Void);
}