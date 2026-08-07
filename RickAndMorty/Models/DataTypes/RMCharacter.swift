//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 27/07/26.
//

import Foundation

struct RMCharacter: Codable {
    let id: Int
    let name: String
    let status: RMCharacterStatus
    let species: String
    let type: String
    let gender: RMCharacterGender
    let origin: RMOrigin
    let location: RMSingeLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
