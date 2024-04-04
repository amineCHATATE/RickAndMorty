//
//  RMSearchView.swift
//  RickMorty
//
//  Created by Amine CHATATE on 30/3/2024.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ inputView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions)
    func rmSearchView(_ searchResultView: RMSearchView, didSelectLocation location: RMLocation)

}

final class RMSearchView: UIView {

    let viewModel: RMSearchViewViewModel
    let noResultView = RMNoSearchResultsView()
    let searchInputView = RMSearchInputView()
    let resultView = RMSearchResultsView()
    
    weak var delegate: RMSearchViewDelegate?
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel){
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(resultView, noResultView, searchInputView)
        addConstraints()
        searchInputView.delegte = self
        searchInputView.configure(with: .init(type: viewModel.config.type))
        
        setUpHandlers(viewModel: viewModel)
        
        resultView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpHandlers(viewModel: RMSearchViewViewModel){
        viewModel.registerOptionChangeBlock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        
        viewModel.registerSearchResultHandler { [weak self] result in
            DispatchQueue.main.async {
                self?.resultView.configure(with: result)
                self?.noResultView.isHidden = true
                self?.resultView.isHidden = false
            }
        }
        
        viewModel.registerNoResultsHandler {[weak self] in
            DispatchQueue.main.async {
                self?.noResultView.isHidden = false
                self?.resultView.isHidden = true
            }
        }
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
            
            resultView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultView.rightAnchor.constraint(equalTo: rightAnchor),
            resultView.leftAnchor.constraint(equalTo: leftAnchor),
            resultView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            noResultView.heightAnchor.constraint(equalToConstant: 150),
            noResultView.widthAnchor.constraint(equalToConstant: 150),
            noResultView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    public func presentKeyboard(){
        searchInputView.presentKeyboard()
    }
    
}

extension RMSearchView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension RMSearchView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
}

extension RMSearchView: RMSearchInputViewDelegate {
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }
    
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }    
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
    
}


extension RMSearchView: RMSearchResultsViewDelegate {
       
    func rmSearchResultsView(_ searchResultView: RMSearchResultsView, didTapLocationAt index: Int) {
        guard let locationModel = viewModel.locationSearchResult(at: index) else { return }
        delegate?.rmSearchView(self, didSelectLocation: locationModel)
    }
    
}
