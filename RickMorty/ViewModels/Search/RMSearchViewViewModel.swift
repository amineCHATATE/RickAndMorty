//
//  RMSearchViewVieModel.swift
//  RickMorty
//
//  Created by Amine CHATATE on 30/3/2024.
//

import Foundation

final class RMSearchViewViewModel {
    
    let config: RMSearchViewController.Config
    private var optionMap: [RMSearchInputViewViewModel.DynamicOptions: String] = [:]
    
    private var searchText = ""

    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOptions, String)) -> Void)?

    private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?

    private var noResultsHandler: (() -> Void)?

    private var searchResultModel: Codable?
        
    init(config: RMSearchViewController.Config){
        self.config = config
    }
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }

    public func registerNoResultsHandler(_ block: @escaping () -> Void) {
        self.noResultsHandler = block
    }
    
    public func executeSearch(){

        var queryParam: [URLQueryItem] = [URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))]
        
        queryParam.append(contentsOf: optionMap.enumerated().compactMap({_, element in
            let key: RMSearchInputViewViewModel.DynamicOptions = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        
        let request = RMRequest(endpoint: config.type.endpoint, queryParameters: queryParam)

        switch config.type.endpoint {
            case .character:
                makeSearchApiCall(RMGetAllCharactersResponse.self, request: request)
            case .episode:
                makeSearchApiCall(RMGetAllEpisodesResponse.self, request: request)
            case .location:
                makeSearchApiCall(RMGetAllLocationsResponse.self, request: request)
        }
        
    }
    
    private func makeSearchApiCall<T: Codable>(_ type: T.Type, request: RMRequest){
        RMservice.shared.execute(request, expecting: type) { [weak self] result in
            switch result {
                case .success(let model):
                    self?.processSearchResults(model: model)
                case .failure(let error):
                    self?.handleNoResults()
                    print("\(error.localizedDescription)")
            }
        }
    }
    
    private func processSearchResults(model: Codable){
        var resultVM: RMSearchResultViewModel?
        if let charactersResponse = model as? RMGetAllCharactersResponse {
            resultVM = .characters(charactersResponse.results.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(charcterName: character.name, charcterStatus: character.status, characterImageUrl: URL(string: character.image))
            }))
        }
        else if let episodesResponse = model as? RMGetAllEpisodesResponse {
            resultVM = .episodes(episodesResponse.results.compactMap({ episode in
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: episode.url))
            }))
        }
        else if let locationsResponse = model as? RMGetAllLocationsResponse {
            resultVM = .locations(locationsResponse.results.compactMap({ location in
                return RMLocationTableViewCellViewModel(location: location)
            }))
        }
        else
        {

        }
        
        if let results = resultVM {
            self.searchResultModel = model
            self.searchResultHandler?(results)
        } else {
            self.handleNoResults()
        }
        
    }
    
    private func handleNoResults(){
        noResultsHandler?()
    }
    
    public func set(query text: String) {
        self.searchText = text
    }

    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOptions) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }

    public func registerOptionChangeBlock(_ block: @escaping ((RMSearchInputViewViewModel.DynamicOptions, String)) -> Void) {
        self.optionMapUpdateBlock = block
    }
    
    public func locationSearchResult(at index: Int) -> RMLocation? {
        guard let searchModel = searchResultModel as? RMGetAllLocationsResponse else { fatalError() }
        return searchModel.results[index]
    }
}
