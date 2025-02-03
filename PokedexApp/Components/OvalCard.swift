//
//  SwiftUIView.swift
//  PokedexApp
//
//  Created by MH on 15/01/2025.
//

import SwiftUI

struct OvalCard: View {
    
    let titleName: String
    let imageUrl: String
    let numberID: Int
    let bgColor: Color
    
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
                .stroke(.gray.opacity(0.2),lineWidth: 2)
        }

    }
}

private extension OvalCard {
    
    var imageSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .frame(width: 120,height: 100)
                .foregroundStyle(bgColor)
            AsyncImage(url: URL(string: imageUrl)) { image in
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
            Text(titleName.capitalized)
                .font(.system(.title3, weight: .semibold))
            Text("N\(numberID)")
                .font(.caption)
        }
    }
}

#Preview {
    OvalCard(
        titleName: "Squirtle",
        imageUrl: "pokemon-agua",
        numberID: 007,
        bgColor: Color.bgBlue
    )
    .padding()
}
