//
//  RMService.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 27/07/26.
//

import Foundation

/// Primary API Service object to get Rick and Morty data
final class RMService {
    /// Shared signleton instance
    static let shared = RMService()
    
    /// Everyone force to use shred not create `RMService` object in outside
    /// Privatized constructor
    private init() {}
    
    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request Instance
    ///   - type: the type of object we expect to get back
    ///   - completion: Callback with data or error
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        
        print("Api call: \(request.url?.absoluteString)")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            // Decode response
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    // MARK: - Private
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = rmRequest.httpMethod
        
        return request
    }
}
