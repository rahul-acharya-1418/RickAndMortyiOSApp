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
    
    private var searchResultHandler:((RMSearchResultViewModel) -> Void)?
    private var noSearchResultHandler:(() -> Void)?
    
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
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }
    
    public func registerNoSearchResultHandler(_ block: @escaping () -> Void) {
        self.noSearchResultHandler = block
    }
    
    public func executeSearch() {
        // Test Search
        var queryParams: [URLQueryItem] = [
            URLQueryItem(
                name: "name",
                value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            )
        ]
        
        // add options
        queryParams.append(contentsOf: optionsMap.enumerated().compactMap({ _, element in
            let key = element.key
            let value = element.value
            
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        
        // create request
        let request = RMRequest(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )
        
        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
        }
    }
    
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(request, expecting: type.self) { [weak self] result in
            // Notify view of results, no results or error
            switch result {
            case .success(let model):
                // Episodes, Characters: collectionView; location: tableView
                self?.processSearchResults(model: model)
            case .failure:
                self?.handleNoResults()
            }
        }
    }
    
    private func processSearchResults(model: Codable) {
        var resultsVM: RMSearchResultViewModel?
        if let characterResults = model as? RMGetAllCharactersResponse {
            resultsVM = .characters(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image)
                )}))
        }
        else if let episodeResults = model as? RMGetAllEpisodesResponse {
            resultsVM = .episodes(episodeResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            }))
        }
        else if let locationResults = model as? RMGetAllLocationsResponse {
            resultsVM = .locations(locationResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
        }
        
        if let resultsVM {
            self.searchResultHandler?(resultsVM)
        } else {
            self.handleNoResults()
        }
    }
    
    private func handleNoResults() {
        noSearchResultHandler?()
    }
}
