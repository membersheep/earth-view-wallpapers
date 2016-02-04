//
//  EarthImageService.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 04/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation
import Alamofire
import HTMLReader

enum EarthImageServiceError: ErrorType {
    case GenericError
}

class EarthImageService: ImageServiceProtocol {
    
    private let EARTHVIEW_URL = "https://earthview.withgoogle.com/"
    private let BACKGROUND_CLASS_NAME = "background"
    
    func getImage(completionHandler: Result<NSURL> -> Void) {
        self.downloadHTMLPage({result in
            switch result {
            case .Success(let document):
                self.getImageUrlfromHTML(document, completionHandler: {result in
                    switch result {
                    case .Success(let urlString):
                        self.downloadImage(urlString, completionHandler: {result in
                            switch result {
                            case .Success(let fileName):
                                completionHandler(Result.Success(fileName))
                            case .Error(let error):
                                print(error)
                            }
                        })
                    case .Error(let error):
                        print(error)
                    }
                })
            case .Error(let error):
                print(error)
            }
        })
    }
    
    func downloadHTMLPage(completionHandler: Result<HTMLDocument> -> Void) {
        Alamofire.request(.GET, EARTHVIEW_URL)
            .responseString { responseString in
                guard responseString.result.error == nil else {
                    completionHandler(Result.Error(EarthImageServiceError.GenericError))
                    return
                }
                guard let htmlAsString = responseString.result.value else {
                    completionHandler(Result.Error(EarthImageServiceError.GenericError))
                    return
                }
                
                let doc = HTMLDocument(string: htmlAsString)
                
                completionHandler(Result.Success(doc))
        }
    }
    
    func getImageUrlfromHTML(document:HTMLDocument, completionHandler: Result<URLStringConvertible> -> Void) {
        let divs = document.nodesMatchingSelector("div");
        
        let backgroundDiv = divs.filter({ div in div.hasClass("background") }).first as? HTMLElement
        
        guard let div = backgroundDiv else {
            completionHandler(Result.Error(EarthImageServiceError.GenericError))
            return
        }
        guard let styleAttributeValue = div.objectForKeyedSubscript("style") else {
            completionHandler(Result.Error(EarthImageServiceError.GenericError))
            return
        }
        guard let fullUrlString: String = styleAttributeValue as? String else {
            completionHandler(Result.Error(EarthImageServiceError.GenericError))
            return
        }
        
        let urlString = String(fullUrlString.componentsSeparatedByString("(")[1].characters.filter({$0 != ")" && $0 != ";"}))
        
        completionHandler(Result.Success(urlString))
    }
    
    func downloadImage(imgURL: URLStringConvertible, completionHandler: Result<NSURL> -> Void) {
        print("Downloading \(imgURL)")
        
        Alamofire.download(.GET, imgURL) { temporaryURL, response in
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let pathComponent = response.suggestedFilename
            
            return directoryURL.URLByAppendingPathComponent(pathComponent!)
        }.progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                print(totalBytesRead)
                
                // This closure is NOT called on the main queue for performance
                // reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    print("Total bytes read on main queue: \(totalBytesRead)")
                }
        }.response { _, response, _, error in
                if let error = error {
                    print("Failed with error: \(error)")
                } else {
                    print("Downloaded file successfully")
                    let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                    directoryURL.URLByAppendingPathComponent(response!.suggestedFilename!)
                    completionHandler(Result.Success(directoryURL.URLByAppendingPathComponent(response!.suggestedFilename!)));
                }
        }
    }
}