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
    let numberID: String
    
    var body: some View {
        HStack {
            imageSection
            VStack(alignment: .leading) {
                specificationSection
                tagViewSection
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
                .foregroundStyle(.cyan.opacity(0.4))
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
            Text(titleName)
                .font(.system(.title3, weight: .semibold))
            Text("N\(numberID)")
                .font(.caption)
        }
    }
    
    var tagViewSection: some View {
        HStack {
            TagView(content: TagView.Content(description: ""), style: TagView.Style.standar)
            TagView(content: TagView.Content(description: ""), style: TagView.Style.standar)
        }
    }
}

#Preview {
    OvalCard(
        titleName: "Squirtle",
        imageUrl: "pokemon-agua",
        numberID: "007"
    )
    .padding()
}
