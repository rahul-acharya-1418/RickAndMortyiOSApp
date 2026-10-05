//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 26/09/26.
//

import UIKit
protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel {
    
    private let endpointUrl: URL?
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType {
        case information(viewModel: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public private(set) var cellViewModels: [SectionType] = []
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    // MARK: - Init
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    
    // MARK: - Public
    
    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }
    
    // MARK: - Private
    private func createCellViewModels() {
        guard let dataTuple else {
            return
        }
        
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        
        var createdString = episode.created
        if let created = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: created)
        }
        
        
        cellViewModels = [
            .information(viewModel: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString),
            ]),
            .characters(viewModel: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
            }))
        ]
    }
    
    /// Fetch backing episode model
    public func fetchEpisodeDate() {
        guard let endpointUrl,
              let request = RMRequest(url: endpointUrl) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.fetchRelatedCharacters(episode: success)
            case .failure:
                break
            }
        }
    }
    
    private func fetchRelatedCharacters(episode: RMEpisode) {
        let requests = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })
        
        /// 10 of parallel request
        /// Notified once all done
        
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        for request in requests {
            group.enter() /// +20
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {/// defer means last thing to run
                    group.leave() /// -20
                }
                switch result {
                case .success(let modle):
                    characters.append(modle)
                case .failure(let failure):
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (
                episode: episode,
                characters: characters
            )
        }
    }
}
