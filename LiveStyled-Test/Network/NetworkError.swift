//
//  NetworkError.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/7/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

/// Possible networking error
///
/// - dataIsNotEncodable: data cannot be encoded in format you have specified
/// - stringFailedToDecode: failed to decode data with given encoding
enum NetworkError: Error {
    case dataIsNotEncodable(_: Any)
    case stringFailedToDecode(_: Data, encoding: String.Encoding)
    case invalidURL(_: String)
    case badResponse
    case badStatusCode
//    case error(response: HTTPURLResponse)
//    case noResponse(_: ResponseProtocol)
    case missingEndpoint
//    case failedToParseJSON(_: NSDictionary, _: ResponseProtocol)
    case failedToParseJSONDictionary(_: [String: Any?])
    case failedToParseJSONData
    case failedToParseImageData(_: Data)
}
