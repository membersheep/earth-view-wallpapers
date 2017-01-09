//
//  EarthImageService.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 04/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation
import HTMLReader

extension RequestSender {
    var host: String {
        return "https://earthview.withgoogle.com/"
    }
}

struct EarthImageService: ImageDownloadService {
    
    fileprivate let EARTHVIEW_URL = "https://earthview.withgoogle.com/"
    fileprivate let BACKGROUND_CLASS_NAME = "background"
    fileprivate let BACKGROUND_ATTRIBUTE_NAME = "style"
    
    internal func getImage(_ completionHandler: @escaping (Result<URL, ImageServiceError>) -> Void) {
        self.downloadHTMLPage({
            result in
            switch result {
            case .success(let document):
                self.getImageUrlfromHTML(document, completionHandler: {
                    result in
                    switch result {
                    case .Success(let urlString):
                        self.downloadImage(urlString, completionHandler: {
                            result in
                            switch result {
                            case .Success(let fileName):
                                completionHandler(Result.Success(fileName))
                            case .Error(let error):
                                completionHandler(Result.Error(error))
                            }
                        })
                    case .Error(let error):
                        completionHandler(Result.Error(error))
                    }
                })
            case .error(let error):
                completionHandler(Result.error(error))
            }
        })
    }
    
    fileprivate func downloadHTMLPage(_ completionHandler: @escaping (Result<HTMLDocument, ImageServiceError>) -> Void) {
        HTTPRequestSender().send(HTMLPageRequest()) { page in
            guard let htmlAsString = page?.code else {
                completionHandler(Result.Error(ImageServiceError.EmptyResponseError))
                return
            }
            let doc = HTMLDocument(string: htmlAsString)
            completionHandler(Result.Success(doc))
        }
    }
    
    fileprivate func getImageUrlfromHTML(_ document:HTMLDocument, completionHandler: (Result<URLStringConvertible, ImageServiceError>) -> Void) {
        let divs = document.nodes(matchingSelector: "div");
        
        let backgroundDiv = divs.filter({ div in (div as AnyObject).hasClass(BACKGROUND_CLASS_NAME) }).first as? HTMLElement
        
        guard let div = backgroundDiv else {
            completionHandler(Result.Error(ImageServiceError.ParserError))
            return
        }
        guard let styleAttributeValue = div.objectForKeyedSubscript(BACKGROUND_ATTRIBUTE_NAME) else {
            completionHandler(Result.Error(ImageServiceError.ParserError))
            return
        }
        guard let fullUrlString: String = styleAttributeValue as? String else {
            completionHandler(Result.Error(ImageServiceError.ParserError))
            return
        }
        
        let urlString = String(fullUrlString.components(separatedBy: "(")[1].characters.filter({$0 != ")" && $0 != ";"}))
        
        completionHandler(Result.Success(urlString))
    }
    
    fileprivate func downloadImage(_ imgURL: URLStringConvertible, completionHandler: @escaping (Result<URL, ImageServiceError>) -> Void) {
//        Alamofire.download(.GET, imgURL) {
//            temporaryURL, response in
//            let fileManager = NSFileManager.defaultManager()
//            let directoryURL = fileManager.URLsForDirectory(.PicturesDirectory, inDomains: .UserDomainMask)[0]
//            let pathComponent = response.suggestedFilename
//            return directoryURL.URLByAppendingPathComponent(pathComponent!)
//        }.response {
//            _, response, _, error in
//            if let error = error {
//                completionHandler(Result.Error(ImageServiceError.ImageDownloadError(description: error.localizedDescription)))
//            } else {
//                let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.PicturesDirectory, inDomains: .UserDomainMask)[0]
//                directoryURL.URLByAppendingPathComponent(response!.suggestedFilename!)
//                completionHandler(Result.Success(directoryURL.URLByAppendingPathComponent(response!.suggestedFilename!)));
//            }
//        }
    }
}
