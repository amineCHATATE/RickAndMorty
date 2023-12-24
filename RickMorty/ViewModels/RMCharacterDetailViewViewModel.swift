//
//  RMCharacterDetailViewViewModel.swift
//  RickMorty
//
//  Created by Amine CHATATE on 18/12/2023.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    
    let character: RMCharacter
    
    init(character: RMCharacter){
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
