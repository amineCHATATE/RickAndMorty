//
//  RMSettingsView.swift
//  RickMorty
//
//  Created by Amine CHATATE on 3/3/2024.
//

import SwiftUI

struct RMSettingsView: View {
    var viewModel: RMSettingsViewViewModel
    
    init(viewModel: RMSettingsViewViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.cellViewModels){ viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .padding(6)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
                Spacer()
            }
            .padding(.bottom, 3)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}

struct RMSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.map({ option in
            return RMSettingsCellViewModel(type: option) { option in
                
            }
        })))
    }
}
