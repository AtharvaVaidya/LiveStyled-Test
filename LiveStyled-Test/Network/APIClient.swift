//
//  APIService.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/6/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//
import Foundation
import Combine

protocol APIClientProtocol {
    func send<T: APIRequest>(request: T) -> AnyPublisher<Data, NetworkError>
}

class APIClient: APIClientProtocol {
    func send<T: APIRequest>(request: T) -> AnyPublisher<Data, NetworkError> {
        let urlRequest = request.urlRequest()
        
        let publisher = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ (data, response) -> Data in
                guard let response = response as? HTTPURLResponse else {
                    print("Bad status code")
                    throw NetworkError.badResponse
                }
                
                if response.statusCode != 200 {
                    print("Status code: \(response.statusCode)")
                    throw NetworkError.badStatusCode
                }
                
                return data
            })
            .mapError({ (error) -> NetworkError in
                return NetworkError.badResponse
            })
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    func send<T: APIRequest>(request: T) -> AnyPublisher<T.Response, NetworkError> where T.Response: Codable {
        let urlRequest = request.urlRequest()
        
        let publisher = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .retry(5)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse else {
                    print("Bad status code")
                    throw NetworkError.badResponse
                }
                
                if response.statusCode != 200 {
                    print("Status code: \(response.statusCode)")
                    throw NetworkError.badStatusCode
                }
                
                return data
            }
            .decode(type: T.Response.self, decoder: JSONDecoder())
            .mapError { (error) -> NetworkError in
                return NetworkError.failedToParseJSONData
            }
            .eraseToAnyPublisher()
        
        return publisher
    }
}
