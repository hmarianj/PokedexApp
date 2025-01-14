//
//  ListView.swift
//  PokedexApp
//
//  Created by MH on 07/01/2025.
//

import SwiftUI

struct CardView: View {
    
    let pokemonType: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                titleView
                TagView(content: TagView.Content(description: "water", iconType: "aqua-type", background: .blue.opacity(0.6)))
                TagView(content: TagView.Content(description: "fire", iconType: "aqua-type", background: .red.opacity(0.6)))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            HStack {
                Spacer()
                ZStack {
                    pokeballImageBackground
                    
                    Image(pokemonType)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                }
            }
            .offset(x: 30)
            .background(Color.cyan.opacity(0.4))
        }
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
    }
}

private extension CardView {
    var titleView: some View {
        Text("Pokemon")
            .font(.system(.title2, weight: .bold))
            .foregroundStyle(.white)
            .multilineTextAlignment(.leading)
    }
    
    var pokeballImageBackground: some View {
        Image("pokeball-bg")
            .resizable()
            .frame(width: 140, height: 140)
    }
}



#Preview {
    HStack {
        CardView(pokemonType: "pokemon-agua")
        CardView(pokemonType: "pokemon-agua")
    }
}
