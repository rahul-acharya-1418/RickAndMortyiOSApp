//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 01/10/26.
//

import SwiftUI

struct RMSettingsView: View {
    let viewModel: RMSettingsViewViewModel
    
    init(viewModel: RMSettingsViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.cellViewModels) { viewmodel in
            HStack {
                if let image = viewmodel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Color(viewmodel.iconContainerColor))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                Text(viewmodel.title)
                    .padding(.leading, 10)
                
                Spacer()
            }
            .padding(.bottom, 3)
            .onTapGesture {
                viewmodel.onTapHandler(viewmodel.type)
            }
        }
    }
}

#Preview {
    RMSettingsView(
        viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0) { option in
                
            }
        }))
    )
}
