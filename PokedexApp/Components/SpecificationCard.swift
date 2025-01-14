//
//  SpecificationView.swift
//  PokedexApp
//
//  Created by MH on 14/01/2025.
//

import SwiftUI


struct SpecificationCard: View {
    var imageName: String
    var title: String
    var value: String
    var metric: String
    
    var body: some View {
        VStack {
            titleSection
            descriptionSection
        }
    }
}

private extension SpecificationCard {
    var titleSection: some View {
        HStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
    }
    
    var descriptionSection: some View {
        Text(value + metric)
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
        imageName: "weigth-icon",
        title: "Weigth",
        value: "14,5 " ,
        metric: "kg"
    )
}
