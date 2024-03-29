//
//  RMCharacterstatus.swift
//  RickMorty
//
//  Created by Amine CHATATE on 13/12/2023.
//

import Foundation

enum RMCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        default:
            return "Unknown"
        }
    }
}
