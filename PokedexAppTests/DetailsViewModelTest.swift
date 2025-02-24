//
//  DetailsViewModelTest.swift
//  PokedexAppTests
//
//  Created by MH on 06/01/2025.
//

@testable import PokedexApp
import XCTest

@MainActor
final class DetailsViewModelTest: XCTestCase {
    var sut: DetailsView.ViewModel!
    var mockService: ServiceMocks!

    override func setUpWithError() throws {
        mockService = ServiceMocks(shouldFail: false)
        sut = DetailsView.ViewModel(pokemonService: mockService)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockService = nil
    }

    func testLoadPokemonSpeciesData() async throws {
        // Given
        let expectedGenderRate = 2
        let expectedEvolutionURL = ""

        // When
        await sut.loadPokemonSpeciesData(id: 4)

        // Then
        XCTAssertEqual(sut.pokemonSpecies?.genderRate, expectedGenderRate)
        XCTAssertEqual(sut.pokemonSpecies?.evolutionChain.url, expectedEvolutionURL)
    }

    func testLoadPokemonSpeciesDataFailure() async throws {
        // Given
        mockService = ServiceMocks(shouldFail: true)
        sut = DetailsView.ViewModel(pokemonService: mockService)

        // When
        await sut.loadPokemonSpeciesData(id: 4)

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.displayError)
    }

    func testLoadPokemonDetails() async throws {
        // Given
        let expectedHeight = 12
        let expectedWeight = 12

        // When
        await sut.loadPokemonDetails(id: 4)

        // Then
        XCTAssertEqual(sut.pokemonDetails?.height, expectedHeight)
        XCTAssertEqual(sut.pokemonDetails?.weight, expectedWeight)
    }

    func testLoadTypeWeaknesses() async throws {
        // Given
        let expectedWeaknesses = ["water"]

        // When
        let fireType = PokemonDetails.Types(type: PokemonDetails.TypeDetail(name: "fire"))
        await sut.loadWeaknesses(types: [fireType])

        // Then
        XCTAssertEqual(sut.weaknesses, expectedWeaknesses)
    }

    func testLoadEvolutions() async throws {
        // Given
        let expectedEvolution = "charmander"

        // When
        await sut.loadPokemonSpeciesData(id: 4)

        // Then
        XCTAssertEqual(sut.evolutionPokemons.first?.name, expectedEvolution)
    }
}
