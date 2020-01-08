//
//  NetworkError.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/7/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

/// Possible networking errors
enum NetworkError: Error {
    case badResponse
    case badStatusCode
    case failedToParseJSONData
    case failedToParseImageData(_: Data)
}
