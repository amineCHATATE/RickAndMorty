//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickMorty
//
//  Created by Amine CHATATE on 1/1/2024.
//

import Foundation

protocol RMEpisodeDataRender {
    var name: String { get }
    var airDate: String { get }
    var episode: String { get }
}

final class RMCharacterEpisodeCollectionViewCellViewModel {
    
    private let episodeDataUrl: URL?
    private var isFetching = false
    private var dataBlock: ((RMEpisodeDataRender) -> Void)?
    
    private var episode: RMEpisode? {
        didSet {
            guard let model = episode else { return }
            self.dataBlock?(model)
        }
    }
    
    init(episodeDataUrl: URL?){
        self.episodeDataUrl = episodeDataUrl
    }
    
    public func registerForData(_ block: @escaping (RMEpisodeDataRender) -> Void){
        self.dataBlock = block
    }
    
    public func fetchEpisodes(){
        guard !isFetching else {
            if let model = episode {
                self.dataBlock?(model)
            }
            return
        }
        
        guard let url = episodeDataUrl, let request = RMRequest(url: url) else { return }
        
        isFetching = true
        
        RMservice.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let viewModel):
                DispatchQueue.main.async {
                    self?.episode = viewModel
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
