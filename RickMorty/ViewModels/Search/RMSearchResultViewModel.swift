//
//  RMSearchResultViewModel.swift
//  RickMorty
//
//  Created by Amine CHATATE on 31/3/2024.
//

import Foundation
import SwiftUI

enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
