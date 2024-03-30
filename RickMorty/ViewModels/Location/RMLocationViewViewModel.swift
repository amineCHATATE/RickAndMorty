//
//  RMLocationViewViewModel.swift
//  RickMorty
//
//  Created by Amine CHATATE on 16/3/2024.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocation()
}

final class RMLocationViewViewModel {
    
    weak var delegate: RMLocationViewViewModelDelegate?
    
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    private var apiInfo: RMGetAllLocationsResponse.Info?
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
    init() {}
    
    public func location(index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return locations[index]
    }
    
    public func fetchLocations(){
        RMservice.shared.execute(.listLocationsRequests, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocation()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
