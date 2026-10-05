//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 05/10/26.
//

import Foundation

final class RMLocationViewViewModel {
    
    private var locations: [RMLocation] = []
    
    // Location response info
    // Will contain next url, if present
    
    private var cellViewModels: [String] = []
    
    init() {
        
    }
    
    public func fetchLocation() {
        RMService.shared.execute(.listLocationRequests, expecting: String.self) { result in
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                break
            }
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
