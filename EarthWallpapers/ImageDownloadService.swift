//
//  ImageServiceProtocol.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 03/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

enum ImageServiceError: Error {
    case genericError
    case imageDownloadError(description: String)
    case parserError
    case htmlDownloadError(description: String)
    case emptyResponseError
}

protocol ImageDownloadService {
    func getImage(_ completionHandler: (Result<URL, ImageServiceError>) -> Void);
}
