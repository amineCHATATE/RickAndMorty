//
//  RMGetAllEpisodesResponse.swift
//  RickMorty
//
//  Created by Amine CHATATE on 14/12/2023.
//

import Foundation

struct RMGetAllEpisodesResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [RMEpisode]
}
