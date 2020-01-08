//
//  ImageRequest.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/8/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit

class ImageRequest: APIRequest {    
    typealias Response = UIImage
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func urlRequest() -> URLRequest {
        let request = URLRequest(url: url)
        
        return request
    }
}
