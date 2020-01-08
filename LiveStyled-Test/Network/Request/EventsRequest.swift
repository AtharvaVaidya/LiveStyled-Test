//
//  EventsRequest.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/7/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

class EventsRequest: APIRequest {
    typealias Response = [Event]
    
    let endpoint: APIEndPoint
    let serviceConfig: APIServiceConfig
    
    init(page: Int = 0) {
        self.endpoint = APIEndPoint(endpoint: "/events", paginated: .yes(page))
        self.serviceConfig = .defaultConfig
    }
    
    func urlRequest() -> URLRequest {
        let baseURL = serviceConfig.url
        
        guard let url = URL(string: baseURL.absoluteString + endpoint.stringRepresentation) else {
            return URLRequest(url: baseURL, cachePolicy: serviceConfig.cachePolicy, timeoutInterval: serviceConfig.timeout)
        }
        
        let request = URLRequest(url: url, cachePolicy: serviceConfig.cachePolicy, timeoutInterval: serviceConfig.timeout)
        
        return request
    }
}
