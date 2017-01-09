//
//  HTTPRequestSender
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 25/11/2016.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

struct HTTPRequestSender: RequestSender {
    func send<T: Request>(_ request: T, handler: @escaping (T.Response?) -> Void) {
        let url = URL(string: host.appending(request.path))!
        var urlRequest = URLRequest(url: url)
        request.httpMethod = request.method.rawValue
        // request.httpBody = ???
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            data, res, error in
            if let data = data, let res = T.Response.parse(data: data) {
                DispatchQueue.main.async {
                    handler(res)
                }
            } else {
                DispatchQueue.main.async {
                    handler(nil)
                }
            }
        }
        task.resume()
    }
}
