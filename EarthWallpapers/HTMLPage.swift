//
//  HTMLPage.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 25/11/2016.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

struct HTMLPage {
    let code: String
    
    init?(data: Data) {
        // From Data to parsed html
    }
}

extension HTMLPage: Decodable {
    static func parse(data: Data) -> HTMLPage? {
        return HTMLPage(data: data)
    }
}

struct HTMLPageRequest: Request {
    var path: String {
        return "/"
    }
    let method: HTTPMethod = .GET
    
    typealias Response = HTMLPage
}
