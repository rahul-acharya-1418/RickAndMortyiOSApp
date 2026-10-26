//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 15/10/26.
//

import Foundation

final class RMSearchResultViewModel {
    public private(set) var results: RMSearchResultType
    private var next: String?
    
    init(results: RMSearchResultType, next: String?) {
        self.results = results
        self.next = next
    }
    
    public private(set) var isLoadinMoreResults = false
    
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    public func fetchAdditionalLocations(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void) {
        
        guard !isLoadinMoreResults else {
            return
        }
        
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        self.isLoadinMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            print("Failed to create request")
            return
        }
        // fetch character here
        print("we are fetching more data")
        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let responseModel):
                let moreResult = responseModel.results
                let info = responseModel.info
                self.next = info.next // Capture new pagination url
                
                let additionalLocations = moreResult.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                })
                
                var newResults: [RMLocationTableViewCellViewModel] = []
                switch self.results {
                case .characters, .episodes:
                    break
                case .locations(let existingResults):
                    newResults = existingResults + additionalLocations
                    self.results = .locations(newResults)
                }
                
                DispatchQueue.main.async {
                    self.isLoadinMoreResults = false
                    
                    // Notify via callback
                    completion(newResults)
                }
            case .failure(let failure):
                print(String(describing: failure))
                self.isLoadinMoreResults = false
            }
        }
    }
    
    func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {
        
        guard !isLoadinMoreResults else {
            return
        }
        
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        self.isLoadinMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            print("Failed to create request")
            return
        }
        
        switch results {
        case .characters(let existingResults):
            // fetch character here
            print("we are fetching more data")
            RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let responseModel):
                    let moreResult = responseModel.results
                    let info = responseModel.info
                    self.next = info.next // Capture new pagination url
                    
                    let additionalResults = moreResult.compactMap({
                        return RMCharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageUrl: URL(string: $0.image))
                    })
                    
                    var newResults: [RMCharacterCollectionViewCellViewModel] = []
                    newResults = existingResults + additionalResults
                    self.results = .characters(newResults)
                    
                    DispatchQueue.main.async {
                        self.isLoadinMoreResults = false
                        
                        // Notify via callback
                        completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self.isLoadinMoreResults = false
                }
            }
        case .episodes(let existingResults):
            // fetch character here
            print("we are fetching more data")
            RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let responseModel):
                    let moreResult = responseModel.results
                    let info = responseModel.info
                    self.next = info.next // Capture new pagination url
                    
                    let additionalResults = moreResult.compactMap({
                        return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
                    })
                    
                    var newResults: [RMCharacterEpisodeCollectionViewCellViewModel] = []
                    newResults = existingResults + additionalResults
                    self.results = .episodes(newResults)
                    
                    DispatchQueue.main.async {
                        self.isLoadinMoreResults = false
                        
                        // Notify via callback
                        completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self.isLoadinMoreResults = false
                }
            }
        case .locations:
            // TableView case
            break
        }
        
    }
}

enum RMSearchResultType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
