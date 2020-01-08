//
//  APIEndPoint.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/7/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

struct APIEndPoint {
    let endpoint: String
    let paginated: Paginated
    
    enum Paginated {
        case no
        case yes(Int)
    }
    
    var stringRepresentation: String {
        switch paginated {
        case .no:
            return endpoint
        case .yes(let page):
            return "\(endpoint)?_page=\(page)"
        }
    }
}
