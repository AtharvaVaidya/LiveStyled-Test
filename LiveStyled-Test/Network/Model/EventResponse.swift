//
//  Event.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/6/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

struct EventResponse: Codable, CustomStringConvertible {
    let id: String
    let title: String
    let image: String
    let startDate: Int
    
    var description: String {
        return title
    }
}
