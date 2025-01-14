//
//  DetailsView.swift
//  PokedexApp
//
//  Created by MH on 06/01/2025.
//

import SwiftUI

struct DetailsView: View {
    let title: String
    let description: String
    let number: String

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
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .offset(y: -80)
            .padding()
        }
        .ignoresSafeArea()
    }
}

private extension DetailsView {
    
    var backgroundImage: some View {
        ZStack {
            Image("pokemon-agua")
                .resizable()
                .scaledToFill()
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
            content: TagView.Content(
                description: "Agua",
                iconType: "aqua-type",
                background: .cyan.opacity(0.2)
            )
        )
    }
    
    var specificationSection: some View {
        VStack(spacing: 24) {
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
}

#Preview {
    DetailsView(
        title: "Squirtle",
        description: "Es un Pokémon de tipo agua, de la primera generación, que se caracteriza por ser una tortuguita con un caparazón blando al nacer. Es uno de los Pokémon iniciales que se pueden elegir en la región de Kanto",
        number: "007"
    )
}
