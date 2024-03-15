//
//  RMSettingsCellViewModel.swift
//  RickMorty
//
//  Created by Amine CHATATE on 25/2/2024.
//

import Foundation
import UIKit

struct RMSettingsCellViewModel: Identifiable {
    
    let id = UUID()
    
    public let type: RMSettingsOption
    public let onTapHandler: (RMSettingsOption) -> Void
    
    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    var image: UIImage? {
        return type.iconImage
    }
    
    var title: String {
        return type.displayTitle
    }
    
    var iconContainerColor: UIColor {
        return type.iconContainerColor
    }

    
}
