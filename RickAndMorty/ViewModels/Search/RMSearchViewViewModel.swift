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
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
}
