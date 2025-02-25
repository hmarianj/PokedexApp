//
//  SpecificationCard.swift
//  PokedexApp
//
//  Created by MH on 14/01/2025.
//

import SwiftUI

struct SpecificationCard: View {
    var model: SpecificationCard.Model

    var body: some View {
        VStack {
            categorySection
            descriptionSection
        }
    }
}

extension SpecificationCard {
    struct Model {
        var imageName: String
        var title: String
        var value: String
        var metric: String
    }
}

private extension SpecificationCard {
    var categorySection: some View {
        HStack {
            Image(model.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
            Text(model.title)
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
    }

    var descriptionSection: some View {
        Text(model.value + model.metric)
            .font(.system(.title3, weight: .semibold))
            .padding()
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(.gray.opacity(0.4), lineWidth: 1)
            }
    }
}

#Preview {
    SpecificationCard(
        model: .init(
            imageName: "weigth-icon",
            title: "Weigth",
            value: "14,5",
            metric: "kg"
        )
    )
}
