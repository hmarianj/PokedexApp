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
    let imageUrl: String
    @StateObject var viewModel: ViewModel = ViewModel()
    
    @State var circleBackgroundColor: Color = .gray

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
            EvolutionView(pokemons: viewModel.evolutionPokemons, bgColor: circleBackgroundColor)
        }
    }
}

#Preview {
    DetailsView(
        id: 1,
        title: "Squirtle",
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
        @Published var weaknesses: [String] = []
        
        init() {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            HTTPClient.shared.jsonDecoder = jsonDecoder
        }
        
        // TODO: Variables para pokemon species (loading/error?)
        
        var maleFraction: CGFloat {
            guard let genderRate = pokemonSpecies?.genderRate, genderRate != -1 else { return 0 }
            return CGFloat(1 - (Double(genderRate) / 8.0))
        }
        
        var pokemonDescription: String {
            guard let entries = pokemonSpecies?.flavorTextEntries else { return "Descripción no disponible" }
            
            let rawText = entries.first(where: { $0.language.name == "en" })?.flavorText.replacingOccurrences(of: "\n", with: " ") ?? "Descripción no disponible"
            
            return rawText
                .replacingOccurrences(of: "POKéMON", with: "Pokémon")
                .replacingOccurrences(of: "POKEMON", with: "Pokémon")
        }
        
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
                await loadWeaknesses(types: response.types)
                
            } catch {
                isLoading = false
                print("Error al cargar los detalles del Pokémon")
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
        
        func loadWeaknesses(types: [PokemonDetails.Types]) async {
            var allWeaknesses: Set<String> = []
            var allResistances: Set<String> = []
            
            for type in types {
                let typeName = type.type.name
                let typeURL = "https://pokeapi.co/api/v2/type/\(typeName)/"
                
                do {
                    let response = try await HTTPClient.shared.execute(
                        Request(
                            urlString: typeURL,
                            method: .get([])
                        ),
                        responseType: TypeAPIResponse.self
                    )
                    
                    let weaknesses = response.damageRelations.doubleDamageFrom.map { $0.name }
                    let resistances = response.damageRelations.halfDamageFrom.map { $0.name }
                    allWeaknesses.formUnion(weaknesses)
                    allResistances.formUnion(resistances)
                    allWeaknesses.subtract(allResistances)
                } catch {
                    isLoading = false
                    // TODO: error view
                }
            }
            
            isLoading = false
            self.weaknesses = Array(allWeaknesses)
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
    
    var bgColor: Color {
        switch self {
        case .black:
            Color.bgBlack
        case .blue:
            Color.bgBlue
        case .brown:
            Color.bgBrown
        case .gray:
            Color.bgGray
        case .green:
            Color.bgGreen
        case .pink:
            Color.bgPink
        case .purple:
            Color.bgPurple
        case .red:
            Color.bgFire
        case .white:
            Color.bgWhiteSmoke
        case .yellow:
            Color.bgYellow
        }
    }
}

enum IconType: String {
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    case stellar
    
    func getColor(callback: @escaping (Color) -> Void) {
        if let uiImage = UIImage(named: iconType) {
            uiImage.getColors { colors in
                if let primary = colors?.background {
                    callback(Color(primary))
                }
            }
        }
    }
    
    var iconType: String {
        switch self {
        case .normal:
            "normal-type"
        case .fighting:
            "fighting-type"
        case .flying:
            "flying-type"
        case .poison:
            "poison-type"
        case .ground:
            "ground-type"
        case .rock:
            "rock-type"
        case .bug:
            "bug-type"
        case .ghost:
            "ghost-type"
        case .steel:
            "steel-type"
        case .fire:
            "fire-type"
        case .water:
            "water-type"
        case .grass:
            "grass-type"
        case .electric:
            "electric-type"
        case .psychic:
            "psychic-type"
        case .ice:
            "ice-type"
        case .dragon:
            "dragon-type"
        case .dark:
            "rock-type"
        case .fairy:
            "fairy-type"
        case .stellar:
            "stellar-type"
        }
    }
}
