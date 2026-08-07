//
//  RMLocation.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 27/07/26.
//

import Foundation

struct RMLocation: Codable {
      let id: Int
      let name: String
      let type: String
      let dimension: String
      let residents: [String]
      let url: String
      let created: String
}
