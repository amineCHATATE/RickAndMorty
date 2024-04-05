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
    
    public var isLoadingMoreLocations = false

    private var didFinishMagination: (() -> Void)?
    
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
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    public func registerDidFinishPaginatitonBlock(_ block: @escaping () -> Void){
        self.didFinishMagination = block
    }
    
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
    
    public func fetchAdditionalLocations(){
        guard !isLoadingMoreLocations else { return }

        guard let nextUrlString = apiInfo?.next, let url = URL(string: nextUrlString) else { return }
        
        isLoadingMoreLocations = true

        guard let request = RMRequest(url: url) else {
            isLoadingMoreLocations = false
            return
        }
        RMservice.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info

                strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({ location in
                    return RMLocationTableViewCellViewModel(location: location)
                }))
                DispatchQueue.main.async {
                    //strongSelf.delegate?.didLoadMoreLocations(with: indexPathToAdd)
                    strongSelf.isLoadingMoreLocations = false
                    strongSelf.didFinishMagination?()
                }
            case .failure(let error):
                print(String(describing: error))
                self?.isLoadingMoreLocations = false
            }
        }
    }
}
