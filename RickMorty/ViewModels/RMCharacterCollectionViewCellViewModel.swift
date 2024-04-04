//
//  RMCharcterCollectionViewCellViewMdel.swift
//  RickMorty
//
//  Created by Amine CHATATE on 17/12/2023.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel: Hashable, Equatable {
    
    public let charcterName: String
    private let charcterStatus: RMCharacterStatus
    private let characterImageUrl:  URL?
    
    public var charcterStatusText: String {
        return "Status: \(charcterStatus.text)"
    }
 
    init(charcterName: String, charcterStatus: RMCharacterStatus, characterImageUrl:  URL?) {
        self.charcterName = charcterName
        self.charcterStatus = charcterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public func fetchImage(completion: @escaping(Result<Data, Error>) -> Void){
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downloadImage(url, completion: completion)
    }
    
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(charcterName)
        hasher.combine(charcterStatus)
        hasher.combine(characterImageUrl)
    }
}
