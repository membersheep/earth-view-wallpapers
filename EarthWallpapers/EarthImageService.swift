//
//  EarthImageService.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 04/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

class EarthImageService: ImageServiceProtocol {
    
    func getImage(completionHandler: Result<NSURL> -> Void) {
        //get html
        //parse out image url
        //download image
        //save image
    }
    
    func downloadImage(imgURL: NSURL) {
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        let urlConnection: NSURLConnection = NSURLConnection(request: request, delegate: self)!
        urlConnection.start()
    }
    
}