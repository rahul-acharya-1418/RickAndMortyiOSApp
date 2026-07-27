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
    
    /// send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request Instance
    ///   - completion: Callback with data or error
    public func execute(_ request: RMRequest, completion: @escaping () -> Void) {
        
    }
}
