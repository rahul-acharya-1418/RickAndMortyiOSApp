//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 27/07/26.
//

import Foundation

/// Object that represent a singlet API call
final class RMRequest {
    /// API Constants
    private struct constant {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    /// Desired endpoints
    private let endpoint: RMEndpoint
    
    /// Path components for API, if any
    private let pathComponent: Set<String>
    
    /// Query parameters for API, if any
    private let queryParameters: [URLQueryItem]
    
    /// Constructed url for the api request in string formate
    private var urlString: String {
        var string = constant.baseUrl
        
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponent.isEmpty {
            pathComponent.forEach({
                string += "/\($0)"
            })
        }
        
        /// compactMap is used to remove nil value and return array
        /// so it's renrn array and after joined Array to string with `&`
        /// so, it's look like `email=test@test.com&password=123456`
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil}
                    return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }
        
        return string
    }
    
    // MARK: - Public
    
    /// Computed and Constructed Api url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// Desired http method
    public let httpMethod = "GET"
    
    /// Construct request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponent: collections of path components
    ///   - queryParameters: collection of query parameters
    public init(
        endpoint: RMEndpoint,
        pathComponent: Set<String> = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponent = pathComponent
        self.queryParameters = queryParameters
    }
}
