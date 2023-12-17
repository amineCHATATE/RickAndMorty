//
//  CharacterListViewViewModel.swift
//  RickMorty
//
//  Created by Amine CHATATE on 16/12/2023.
//

import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
}

final class RMCharacterListViewViewModel: NSObject {
    
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var characters: [RMCharacter] = [] {
        didSet{
            characters.forEach { character in
                let viewModel = RMCharacterCollectionViewCellViewMdel(charcterName: character.name, charcterStatus: character.status, characterImageUrl: URL(string: character.image))
                characterCollectionViewCellViewMdels.append(viewModel)
            }
        }
    }
    
    private var characterCollectionViewCellViewMdels: [RMCharacterCollectionViewCellViewMdel] = []
    
    func fetchCharacters()  {
        RMservice.shared.execute(.listCharacterRequest, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self?.characters = results
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension RMCharacterListViewViewModel: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterCollectionViewCellViewMdels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharcterCollectionViewCell.identifier, for: indexPath) as? RMCharcterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        let viewModel = characterCollectionViewCellViewMdels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
}


extension RMCharacterListViewViewModel: UICollectionViewDelegate {
    
}


extension RMCharacterListViewViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}
