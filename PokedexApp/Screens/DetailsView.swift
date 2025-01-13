//
//  DescriptionView.swift
//  PokedexApp
//
//  Created by MH on 06/01/2025.
//

import SwiftUI

struct DetailsView: View {
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.largeTitle)
                .bold()
            Text(description)
                .font(.body)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline) // Título en la barra superior
    }
}

#Preview {
    DetailsView(title: "Pokemon", description: "Agua, tierra y fuego.")
}
