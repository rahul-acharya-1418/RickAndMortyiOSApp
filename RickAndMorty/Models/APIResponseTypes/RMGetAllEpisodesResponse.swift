//
//  RMGetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 26/09/26.
//

import Foundation

struct RMGetAllEpisodesResponse: Codable {
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMEpisode]
}
