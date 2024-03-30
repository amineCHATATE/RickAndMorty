//
//  RMLocationDetailViewViewModel.swift
//  RickMorty
//
//  Created by Amine CHATATE on 17/3/2024.
//

import UIKit

protocol RMLocationDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodesDetails()
}

final class RMLocationDetailViewViewModel {

    private let endpointUrl: URL?
    private var dataTuple: (location: RMLocation, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodesDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellVieModel])
        case characters(viewModels: [RMCharacterCollectionViewCellViewMdel])
    }
    
    public weak var delegate: RMLocationDetailViewViewModelDelegate?
    
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
        let location = dataTuple.location
        let characters = dataTuple.characters
        
        var createdString = location.created
        if let createdDate = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: createdDate)
        }
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
                .init(title: "Created", value: createdString),
            ]),
            .characters(viewModels: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewMdel(
                    charcterName: character.name,
                    charcterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
            }))]

    }
    public func fetchLocationData(){
        guard let url = self.endpointUrl, let request = RMRequest(url: url) else { return }
        
        RMservice.shared.execute(request, expecting: RMLocation.self) { [weak self] result in
            switch result {
                case .success(let viewmodel):
                    self?.fetchRetaltedCharacters(location: viewmodel)
                case .failure(let error):
                    print(String(describing: error))
            }
        }
    }
    
    private func fetchRetaltedCharacters(location: RMLocation){
        let requests: [RMRequest] = location.residents.compactMap {
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
                location,
                characters
            )
        }
    }
}
