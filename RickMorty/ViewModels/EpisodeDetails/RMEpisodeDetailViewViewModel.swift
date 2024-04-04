//
//  RMEpisodeDetailViewViewModel.swift
//  RickMorty
//
//  Created by Amine CHATATE on 21/1/2024.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodesDetails()
}

final class RMEpisodeDetailViewViewModel {

    private let endpointUrl: URL?
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodesDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellVieModel])
        case characters(viewModels: [RMCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    public private(set) var cellViewModels: [SectionType] = []
    
    init(endpointUrl: URL?){
        self.endpointUrl = endpointUrl
    }
    
    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }
    
    private func createCellViewModels(){
        guard let dataTuple = dataTuple else {
            return
        }
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        
        var createdString = episode.created
        if let createdDate = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: createdDate) 
        }
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.airDate),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString),
            ]),
            .characters(viewModels: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(
                    charcterName: character.name,
                    charcterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
            }))]

    }
    public func fetchEpisodeData(){
        guard let url = self.endpointUrl, let request = RMRequest(url: url) else { return }
        
        RMservice.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
                case .success(let viewmodel):
                    self?.fetchRetaltedCharacters(episode: viewmodel)
                case .failure(let error):
                    print(String(describing: error))
            }
        }
    }
    
    private func fetchRetaltedCharacters(episode: RMEpisode){
        let requests: [RMRequest] = episode.characters.compactMap {
            return URL(string: $0)
        }.compactMap {
            return RMRequest(url: $0)
        }
        // 10 of parallel requests
        // notified once all done
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        for request in requests {
            group.enter()
            RMservice.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }
                switch result {
                    
                case .success(let character):
                    characters.append(character)
                case .failure(let error):
                    print(String(describing: error))
                }
            }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (
                episode,
                characters
            )
        }
    }
}
