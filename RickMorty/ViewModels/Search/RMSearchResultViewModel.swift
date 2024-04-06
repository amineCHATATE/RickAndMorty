//
//  RMSearchResultType.swift
//  RickMorty
//
//  Created by Amine CHATATE on 31/3/2024.
//

import Foundation
import SwiftUI


final class RMSearchResultViewModel {
    
    public private(set) var results: RMSearchResultType
    private var next: String? = nil
    public private(set) var isLoadingMoreResults = false
    
    init(results: RMSearchResultType, next: String?) {
        self.results = results
        self.next = next
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    public func fetchAdditionalLocations(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void){
        guard !isLoadingMoreResults else { return }
        guard let nextUrlString = next, let url = URL(string: nextUrlString) else { return }
        isLoadingMoreResults = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        RMservice.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.next = info.next

                let additionalLocations = moreResults.compactMap({ location in
                    return RMLocationTableViewCellViewModel(location: location)
                })
                
                var newResults : [RMLocationTableViewCellViewModel] = []
                switch strongSelf.results {
                case .characters(_):
                    break
                case .episodes(_):
                    break
                case .locations(let exixstingResults):
                    newResults = exixstingResults + additionalLocations
                    strongSelf.results = .locations(newResults)
                    break
                }                
                DispatchQueue.main.async {
                    completion(newResults)
                }
            case .failure(let error):
                print(String(describing: error))
                self?.isLoadingMoreResults = false
            }
        }
    }
}


enum RMSearchResultType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
