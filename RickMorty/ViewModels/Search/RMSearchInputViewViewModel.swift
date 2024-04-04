//
//  RMSearchInputViewViewModel.swift
//  RickMorty
//
//  Created by Amine CHATATE on 30/3/2024.
//

import Foundation

final class RMSearchInputViewViewModel {

    private let type: RMSearchViewController.Config.`Type`
    
    enum DynamicOptions: String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
        
        var queryArgument: String {
            switch self {
                case .status:
                    return "status"
                case .gender:
                    return "gender"
                case .locationType:
                    return "type"
            }
            
        }
        
        var choises: [String] {
            switch self {
                case .status:
                    return ["alive", "dead", "unknown"]
                case .gender:
                    return ["male", "female", "genderless", "unknown"]
                case .locationType:
                    return ["cluster", "planet", "microverse"]
            }
        }
    }
    
    init(type: RMSearchViewController.Config.`Type`){
        self.type = type
    }
    
    public var hasDynamicOptions: Bool {
        switch self.type {
            case .character, .location:
                return true
            case .episode:
                return false
        }
    }
    
    public var options: [DynamicOptions] {
        switch self.type {
            case .character:
                return [.status, .gender]
            case .episode:
                return []
            case .location:
                return [.locationType]
        }
    }
    
    public var seachPlaceHolderText: String {
        switch self.type {
            case .character:
                return "Character Name"
            case .episode:
                return "Episode Title"
            case .location:
                return "Location Name"
        }
    }
    
}
