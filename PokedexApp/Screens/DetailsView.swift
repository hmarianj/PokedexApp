//
//  DetailsView.swift
//  PokedexApp
//
//  Created by MH on 06/01/2025.
//

import CoreNetworking
import SwiftUI

struct DetailsView: View {
    let id: Int
    let title: String
    let description: String
    let number: String
    let imageUrl: String
    @StateObject var viewModel: ViewModel = ViewModel()

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
                    GenderView(maleFraction: 0.45) // TODO: parametrizar
                    WeaknessView()
                    evolutionSection
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .offset(y: -80)
            .padding()
        }
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
                    .offset(x: 0, y: -200)
                    .foregroundStyle(pillBackgroundColor)
                    .clipped()
                Image("aqua-icon")
                    .frame(width: 180, height: 180)
                    .offset(y: -60)
            }
        }
    }
    
    var pillBackgroundColor: Color {
        // si tengo pokemon species -> pokemon.apiColor.name.bgColor
        if let pokemonSpecies = viewModel.pokemonSpecies {
            return pokemonSpecies.color.name.bgColor
        } else {
            return .gray
        }
    }
    
    var titleSection: some View {
        Text(title)
            .font(.system(.largeTitle, weight: .bold))
            .multilineTextAlignment(.center)
    }
    
    var numberIDSection: some View {
        Text("N\(id)")
            .font(.headline)
            .foregroundStyle(.gray)
    }
    
    var descriptionSection: some View {
        Text(description)
            .font(.title3)
            .foregroundStyle(.black.opacity(0.8))
    }
    
    @ViewBuilder
    var tagViewSection: some View {
        if let pokemonDetails = viewModel.pokemonDetails {
            HStack {
                ForEach(pokemonDetails.types, id: \.type.name) { type in
                    TagView(
                        content: TagView.Content(type: type.type.name.capitalized),
                        style: TagView.Style.standar
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
            EvolutionView(pokemons: viewModel.evolutionPokemons)
        }
    }
}

#Preview {
    DetailsView(
        id: 1,
        title: "Squirtle",
        description: "Es un Pokémon de tipo agua, de la primera generación, que se caracteriza por ser una tortuguita con un caparazón blando al nacer. Es uno de los Pokémon iniciales que se pueden elegir en la región de Kanto",
        number: "007",
        imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png"
    )
}

extension DetailsView {
    
    func formatValue(_ value: Int) -> String {
        let formattedValue = Double(value) / 10.0
        return String(format: "%.1f", formattedValue)
    }
    
    @MainActor
    class ViewModel: ObservableObject {
        @Published var isLoading: Bool = false
        @Published var pokemonSpecies: PokemonSpecies? = nil
        @Published var pokemonDetails: PokemonDetails? = nil
        @Published var evolutionPokemons: [Pokemon] = []
        
        init() {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            HTTPClient.shared.jsonDecoder = jsonDecoder
        }
        
        // TODO: Variables para pokemon species (loading/error?)
        
        func loadPokemonSpeciesData(id: Int) async {
            isLoading = true
            do {
                let response = try await HTTPClient.shared.execute(
                    Request(
                        urlString: "https://pokeapi.co/api/v2/pokemon-species/\(id)",
                        method: .get([])
                    ),
                    responseType: PokemonSpecies.self
                )
                self.pokemonSpecies = response
                await loadEvolutions(url: response.evolutionChain.url)
            } catch {
                isLoading = false
                // TODO: Error
//                displayError = true
            }
        }

        func loadPokemonDetails(id: Int) async {
            isLoading = true
            do {
                let response = try await HTTPClient.shared.execute(
                    Request(
                        urlString: "https://pokeapi.co/api/v2/pokemon/\(id)",
                        method: .get([])
                    ),
                    responseType: PokemonDetails.self
                )
                self.pokemonDetails = response
            } catch {
                isLoading = false
                // TODO: Error
//                displayError = true
            }
        }
        
        private func loadEvolutions(url: String) async {
            isLoading = true
            // Call evolution api
            do {
                let response = try await HTTPClient.shared.execute(
                    Request(
                        urlString: url,
                        method: .get([])
                    ),
                    responseType: Evolution.self
                )
                isLoading = false
                self.evolutionPokemons = response.pokemons
            } catch {
                isLoading = false
                // TODO: Error
//                displayError = true
            }
            
        }
    }
}

extension Evolution {
    var pokemons: [Pokemon] {
        return chain.allEvolvedPokemons()
    }
}
extension Evolution.Chain {
    func allEvolvedPokemons() -> [Pokemon] {
        // TODO: Si tiene species, agregarlo
        var result: [Pokemon] = []
        result.append(species)
        for evolution in evolvesTo {
            result.append(evolution.species)
            result.append(contentsOf: evolution.allEvolvedPokemons())
        }
        return result
    }
}

extension Evolution.EvolvesTo {
    func allEvolvedPokemons() -> [Pokemon] {
        var result: [Pokemon] = []
        for evolution in evolvesTo {
            result.append(evolution.species)
            result.append(contentsOf: evolution.allEvolvedPokemons())
        }
        return result
    }
}

enum BackgroundColor: String, Codable {
    case black
    case blue
    case brown
    case gray
    case green
    case pink
    case purple
    case red
    case white
    case yellow
    
    // TODO: crear paleta de colores
    var bgColor: Color {
        switch self {
        case .black:
            Color.black
        case .blue:
            Color.blue
        case .brown:
            Color.brown
        case .gray:
            Color.gray
        case .green:
            Color.green
        case .pink:
            Color.pink
        case .purple:
            Color.purple
        case .red:
            Color.red
        case .white:
            Color.white
        case .yellow:
            Color.yellow
        }
    }
}
