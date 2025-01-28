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
            await viewModel.loadPokemonData(id: id)
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
                    .foregroundStyle(.cyan.opacity(0.4))
                    .clipped()
                Image("aqua-icon")
                    .frame(width: 180, height: 180)
                    .offset(y: -60)
            }
        }
    }
    
    var titleSection: some View {
        Text(title)
            .font(.system(.largeTitle, weight: .bold))
            .multilineTextAlignment(.center)
    }
    
    var numberIDSection: some View {
        Text("N\(number)")
            .font(.headline)
            .foregroundStyle(.gray)
    }
    
    var descriptionSection: some View {
        Text(description)
            .font(.title3)
            .foregroundStyle(.black.opacity(0.8))
    }
    
    var tagViewSection: some View {
        // TODO: hacer forEach por cada tag view que contenga
        TagView(
            content: TagView.Content(description: "Water"),
            style: TagView.Style.standar
        )
    }
    
    var specificationSection: some View {
        VStack(spacing: 24) {
            Text("Characteristics")
                .font(.system(.title2, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 6)
            HStack(spacing: 20) {
                SpecificationCard(imageName: "weigth-icon", title: "Weigth", value: "14,5 " , metric: "kg")
                SpecificationCard(imageName: "heigth-icon", title: "Heigth", value: "2,5 " , metric: "m")
            }
            HStack(spacing: 20) {
                SpecificationCard(imageName: "category-icon", title: "Category", value: "Seed" , metric: "")
                SpecificationCard(imageName: "pokeball-icon", title: "Ability", value: "Overgrow" , metric: "")
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
    @MainActor
    class ViewModel: ObservableObject {
        @Published var isLoading: Bool = false
        @Published var pokemonSpecies: PokemonSpecies? = nil
        @Published var evolutionPokemons: [Pokemon] = []
        
        init() {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            HTTPClient.shared.jsonDecoder = jsonDecoder
        }
        
        // TODO: Variables para pokemon species (loading/error?)
        
        func loadPokemonData(id: Int) async {
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
