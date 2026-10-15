//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 15/10/26.
//

import Foundation

enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
