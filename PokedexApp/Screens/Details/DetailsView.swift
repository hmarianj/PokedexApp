//
//  DetailsView.swift
//  PokedexApp
//
//  Created by MH on 06/01/2025.
//

import Combine
import SwiftUI

struct DetailsView: View {
    let id: Int
    let title: String
    let imageUrl: String
    @StateObject var viewModel: ViewModel = ViewModel()
    @State var circleBackgroundColor: Color = .gray
    @AppStorage(AppStorageKeys.myPokemons.rawValue) var myPokemons: [Pokemon] = []

    var body: some View {
        ScrollView {
            backgroundImage
            VStack {
                titleSection
                VStack(alignment: .leading, spacing: 24) {
                    numberIDSection
                    tagViewSection
                    descriptionSection
                    Divider()
                    specificationSection
                    GenderView(maleFraction: viewModel.maleFraction)
                    WeaknessView(weaknesses: viewModel.weaknesses)
                    evolutionSection
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .offset(y: -80)
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                PokeballButton(isCaptured: isCaptured) {
                    withAnimation {
                        toggleCaptured()
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea()
        .task {
            await viewModel.loadPokemonSpeciesData(id: id)
            await viewModel.loadPokemonDetails(id: id)
        }
    }
}

private extension DetailsView {
    
    var backgroundImage: some View {
        ZStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 180, height: 180)
        }
        .frame(maxWidth: .infinity, minHeight: 330)
        .background {
            ZStack {
                Circle()
                    .frame(width: 498, height: 498)
                    .offset(x: 0, y: -160)
                    .foregroundStyle(circleBackgroundColor)
                    .clipped()
                if let firstTypeName = viewModel.pokemonDetails?.types.first?.type.name,
                   let iconType = IconType(rawValue: firstTypeName) {
                    Image(iconType.iconType)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .foregroundStyle(Color.white.opacity(0.2))
                        .offset(y: -20)
                        .onAppear {
                            iconType.getColor { color in
                                withAnimation {
                                    circleBackgroundColor = color
                                }
                            }
                        }
                }
            }
            
        }
    }
    
    var titleSection: some View {
        Text(title.capitalized)
            .font(.system(.largeTitle, weight: .bold))
            .multilineTextAlignment(.center)
    }
    
    var numberIDSection: some View {
        Text("Nº\(String(format: "%03d", id))")
            .font(.headline)
            .foregroundStyle(.gray)
    }
    
    var descriptionSection: some View {
        Text(viewModel.pokemonDescription)
            .font(.title3)
            .foregroundStyle(.black.opacity(0.8))
    }
    
    @ViewBuilder
    var tagViewSection: some View {
        if let pokemonDetails = viewModel.pokemonDetails {
            HStack {
                ForEach(pokemonDetails.types, id: \.type.name) { type in
                    TagView(
                        content: TagView.Content(type: type.type.name),
                        style: TagView.Style.standard
                    )
                }
            }
        } else {
            EmptyView()
        }
    }
    
    var specificationSection: some View {
            VStack(spacing: 24) {
                if let pokemonDetails = viewModel.pokemonDetails {
                Text("Characteristics")
                    .font(.system(.title2, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 6)
                HStack(spacing: 20) {
                    SpecificationCard(
                        imageName: "weigth-icon",
                        title: "Weigth",
                        value:  formatValue(pokemonDetails.weight),
                        metric: "kg"
                    )
                    SpecificationCard(
                        imageName: "heigth-icon",
                        title: "Heigth",
                        value: formatValue(pokemonDetails.height),
                        metric: "m"
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    var evolutionSection: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if !viewModel.evolutionPokemons.isEmpty {
            EvolutionView(
                currentId: id,
                pokemons: viewModel.evolutionPokemons,
                bgColor: circleBackgroundColor
            )
        }
    }
    
    var isCaptured: Bool {
        return myPokemons.contains(where: { item in
            item.id == self.id
        })
    }
    
    func toggleCaptured() {
        if isCaptured {
            myPokemons.removeAll { item in
                item.id == self.id
            }
        } else {
            myPokemons.append(.init(name: title, url: "https://pokeapi.co/api/v2/pokemon/\(id)"))
        }
    }
    
    func formatValue(_ value: Int) -> String {
        let formattedValue = Double(value) / 10.0
        return String(format: "%.1f", formattedValue)
    }
    
}

#Preview {
    DetailsView(
        id: 1,
        title: "Squirtle",
        imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png"
    )
}
