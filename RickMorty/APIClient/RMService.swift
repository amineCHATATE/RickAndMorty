//
//  RMService.swift
//  RickMorty
//
//  Created by Amine CHATATE on 13/12/2023.
//

import Foundation


/// API service caller
final class RMservice {
    
    static let shared = RMservice()
    
    private init(){}
    
    public func execute(_ request: RMRequest, completion: @escaping () -> Void){
        
    }
}
