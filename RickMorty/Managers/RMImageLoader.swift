//
//  ImageLoader.swift
//  RickMorty
//
//  Created by Amine CHATATE on 24/12/2023.
//

import Foundation
import UIKit

final class RMImageLoader {
    
    static let shared = RMImageLoader()
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init(){}
    
    func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void){
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key){
            print("reading from cache : \(key)")
            completion(.success(data as Data))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            print("loading from server : \(key)")
            completion(.success(data))
        }
        task.resume()
    }
}
