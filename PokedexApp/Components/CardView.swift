//
//  ListView.swift
//  PokedexApp
//
//  Created by MH on 07/01/2025.
//

import SwiftUI

struct CardView: View {
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                titleView
                TagView(content: TagView.Content(description: "water", background: .blue.opacity(0.6)))
                TagView(content: TagView.Content(description: "fire", background: .red.opacity(0.6)))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            HStack {
                Spacer()
                ZStack {
                    Image("pokeball")
                        .resizable()
                        .frame(width: 180, height: 180)
                    
                    Image("pokemon-agua")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                }
            }
            .offset(x: 50)
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
}



#Preview {
    HStack {
        CardView()
        CardView()
    }
}
