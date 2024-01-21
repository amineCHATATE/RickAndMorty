//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickMorty
//
//  Created by Amine CHATATE on 1/1/2024.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {
    
    private let imageUrl: URL?
    
    init(imageUrl: URL?){
        self.imageUrl = imageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageurl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downloadImage(imageurl, completion: completion)
    }
}
