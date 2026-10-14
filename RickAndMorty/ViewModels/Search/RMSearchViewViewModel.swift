//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 09/10/26.
//

import Foundation

// Responsibilites
// - show search results
// - show no results view
// - kik off API requests

final class RMSearchViewViewModel {
    let config: RMSearchViewController.Config
    private var optionsMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var searchText = ""
    private var optionsMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    
    // MARK: - Init
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Public
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        optionsMap[option] = value
        let tuple = (option, value)
        optionsMapUpdateBlock?(tuple)
    }
    
    public func registerOptionChangeBlock(
        _ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void
    ) {
        self.optionsMapUpdateBlock = block
    }
    
    public func executeSearch() {
        // Create Request based on filters
        // send API Call
        // Notify view of results, no results or error
    }
}
