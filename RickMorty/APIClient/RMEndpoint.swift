//
//  RMEndpoint.swift
//  RickMorty
//
//  Created by Amine CHATATE on 13/12/2023.
//

import Foundation

@frozen enum RMEndpoint: String, CaseIterable, Hashable {
    case character
    case location
    case episode
}
