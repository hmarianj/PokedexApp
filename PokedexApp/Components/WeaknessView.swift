//
//  WeaknessView.swift
//  PokedexApp
//
//  Created by MH on 15/01/2025.
//

import SwiftUI

struct WeaknessView: View {
    let weaknesses: [String]

    var body: some View {
        VStack {
            titleSection
            ScrollView(.horizontal) {
                HStack {
                    ForEach(weaknesses, id: \.self) { weakness in
                        TagView(content: TagView.Content(type: weakness), style: TagView.Style.category)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

private extension WeaknessView {
    var titleSection: some View {
        Text("Weaknesses")
            .padding(.vertical)
            .font(.system(.title2, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    WeaknessView(
        weaknesses: ["fire", "ice", "poison", "flying", "bug", "ground", "psychic"]
    )
}
