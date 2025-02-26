//
//  OvalCard.swift
//  PokedexApp
//
//  Created by MH on 15/01/2025.
//

import SwiftUI

struct OvalCard: View {
    var model: OvalCard.Model

    var body: some View {
        HStack {
            imageSection
            VStack(alignment: .leading) {
                specificationSection
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 50)
                .stroke(.gray.opacity(0.2), lineWidth: 2)
        }
    }
}

extension OvalCard {
    struct Model {
        let titleName: String
        let imageUrl: String
        let id: Int
        let bgColor: Color
    }
}

private extension OvalCard {
    var imageSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .frame(width: 120, height: 100)
                .foregroundStyle(model.bgColor)
            AsyncImage(url: URL(string: model.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 120, height: 100)
        }
    }

    var specificationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.titleName.capitalized)
                .font(.system(.title3, weight: .semibold))
                .foregroundStyle(.bgBlack)
            Text("Nº\(String(format: "%03d", model.id))")
                .font(.system(.caption2, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(model.bgColor)
                .cornerRadius(16)
        }
    }
}

#Preview {
    OvalCard(
        model: .init(
            titleName: "Squirtle",
            imageUrl: "pokemon-agua",
            id: 007,
            bgColor: Color.bgBlue
        )
    )
    .padding()
}
