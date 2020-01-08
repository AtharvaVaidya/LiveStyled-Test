//
//  APIServiceConfig.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/7/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

public struct APIServiceConfig {
    /// Name of the server configuration, for example: "Testing" or "Production"
    private(set) var name: String

    /// This is the base host url (ie. "http://www.myserver.com/api/v2")
    private(set) var url: URL

    /// These are the global headers which must be included in each session of the service
    private(set) var headers: HeadersDict = [:]

    /// Cache policy you want apply to each request done with this service
    /// By default this is `.useProtocolCachePolicy`.
    public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy

    /// Global timeout for any request. If you want, you can override it in Request
    /// Default value is 15 seconds.
    public var timeout: TimeInterval = 15.0

    /// Initialize a new service configuration
    ///
    /// - Parameters:
    ///   - name: Name of the server configuration, for example: "Testing" or "Production"
    ///   - urlString: base url of the service
    public init?(name: String? = nil, base urlString: String) {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        self.url = url
        self.name = name ?? (url.host ?? "")
    }

    public init(name: String? = nil, base url: URL) {
        self.url = url
        self.name = name ?? (url.host ?? "")
    }
}

extension APIServiceConfig {
    static var defaultConfig: APIServiceConfig {
        return APIServiceConfig(base: URL(string: "https://my-json-server.typicode.com/livestyled/mock-api")!)
    }
}
