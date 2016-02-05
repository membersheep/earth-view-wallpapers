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

struct EarthImageService: ImageServiceProtocol {
    
    private let EARTHVIEW_URL = "https://earthview.withgoogle.com/"
    private let BACKGROUND_CLASS_NAME = "background"
    private let BACKGROUND_ATTRIBUTE_NAME = "style"
    
    internal func getImage(completionHandler: Result<NSURL, ImageServiceError> -> Void) {
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
    
    private func downloadHTMLPage(completionHandler: Result<HTMLDocument, ErrorType> -> Void) {
        Alamofire.request(.GET, EARTHVIEW_URL)
            .responseString {
                response in
                guard response.result.error == nil else {
                    completionHandler(Result.Error(response.result.error!))
                    return
                }
                guard let htmlAsString = response.result.value else {
                    completionHandler(Result.Error(ImageServiceError.EmptyResponseError))
                    return
                }
                
                let doc = HTMLDocument(string: htmlAsString)
                
                completionHandler(Result.Success(doc))
        }
    }
    
    private func getImageUrlfromHTML(document:HTMLDocument, completionHandler: Result<URLStringConvertible, ErrorType> -> Void) {
        let divs = document.nodesMatchingSelector("div");
        
        let backgroundDiv = divs.filter({ div in div.hasClass(BACKGROUND_CLASS_NAME) }).first as? HTMLElement
        
        guard let div = backgroundDiv else {
            completionHandler(Result.Error(ImageServiceError.ParsingError))
            return
        }
        guard let styleAttributeValue = div.objectForKeyedSubscript(BACKGROUND_ATTRIBUTE_NAME) else {
            completionHandler(Result.Error(ImageServiceError.ParsingError))
            return
        }
        guard let fullUrlString: String = styleAttributeValue as? String else {
            completionHandler(Result.Error(ImageServiceError.ParsingError))
            return
        }
        
        let urlString = String(fullUrlString.componentsSeparatedByString("(")[1].characters.filter({$0 != ")" && $0 != ";"}))
        
        completionHandler(Result.Success(urlString))
    }
    
    private func downloadImage(imgURL: URLStringConvertible, completionHandler: Result<NSURL, ErrorType> -> Void) {       
        Alamofire.download(.GET, imgURL) { temporaryURL, response in
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.PicturesDirectory, inDomains: .UserDomainMask)[0]
            let pathComponent = response.suggestedFilename
            
            return directoryURL.URLByAppendingPathComponent(pathComponent!)
        }.response { _, response, _, error in
                if let error = error {
                    completionHandler(Result.Error(error))
                } else {
                    let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.PicturesDirectory, inDomains: .UserDomainMask)[0]
                    directoryURL.URLByAppendingPathComponent(response!.suggestedFilename!)
                    completionHandler(Result.Success(directoryURL.URLByAppendingPathComponent(response!.suggestedFilename!)));
                }
        }
    }
}