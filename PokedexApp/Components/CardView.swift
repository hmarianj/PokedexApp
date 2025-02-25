//
//  CardView.swift
//  PokedexApp
//
//  Created by MH on 07/01/2025.
//

import SwiftUI
import UIImageColors

struct CardView: View {
    @State private var backgroundColor: Color = Color.cyan.opacity(0.4)
    private static var colorCache = NSCache<NSString, UIColor>()
    var model: CardView.Model

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                titleSection
                numberIDSection
            }
        }
        .frame(maxWidth: .infinity, minHeight: 90, alignment: .leading)
        .padding()
        .background {
            cardImageBackground
        }
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
    }
}

extension CardView {
    struct Model {
        let imageUrl: String
        let name: String
        let id: Int
    }
}

private extension CardView {
    var titleSection: some View {
        Text(model.name.capitalized)
            .font(.system(.title2, weight: .bold))
            .foregroundStyle(.white)
            .multilineTextAlignment(.leading)
            .shadow(radius: 2)
    }

    var numberIDSection: some View {
        Text("Nº\(String(format: "%03d", model.id))")
            .font(.system(.caption2, weight: .semibold))
            .foregroundStyle(.gray)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(.white)
            .cornerRadius(16)
    }

    var pokeballImageBackground: some View {
        Image("pokeball-bg")
            .resizable()
            .frame(width: 140, height: 140)
            .offset(x: 30)
    }

    var cardImageBackground: some View {
        HStack {
            Spacer()
            ZStack(alignment: .trailingFirstTextBaseline) {
                pokeballImageBackground
                AsyncImage(url: URL(string: model.imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .scaleEffect(x: 1.5, y: 1.5)
                        .task {
                            extractColors(from: image.asUIImage())
                        }
                } placeholder: {
                    ProgressView()
                }
                .padding(.bottom, 4)
            }
        }
        .background(backgroundColor)
    }

    func extractColors(from image: UIImage) {
        let cacheKey = model.imageUrl as NSString

        if let cachedColor = Self.colorCache.object(forKey: cacheKey) {
            backgroundColor = Color(cachedColor)
            return
        }

        DispatchQueue.global(qos: .userInitiated).async { [cacheKeyString = cacheKey as String] in
            if let colors = image.getColors() {
                if let primaryColor = colors.background {
                    Self.colorCache.setObject(primaryColor, forKey: cacheKeyString as NSString)

                    DispatchQueue.main.async {
                        withAnimation {
                            backgroundColor = Color(primaryColor)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HStack {
        CardView(
            model: .init(
                imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png",
                name: "Pokemon",
                id: 007
            )
        )
        .fixedSize(horizontal: false, vertical: true)
        CardView(
            model: .init(
                imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/8.png",
                name: "Pokemon",
                id: 008
            )
        )
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding()
}
