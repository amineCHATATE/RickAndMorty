//
//  RMCharcterCollectionViewCellViewMdel.swift
//  RickMorty
//
//  Created by Amine CHATATE on 17/12/2023.
//

import Foundation

struct RMCharacterCollectionViewCellViewMdel {
    
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
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
