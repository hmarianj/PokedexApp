//
//  TabNavigationView.swift
//  PokedexApp
//
//  Created by MH on 05/02/2025.
//

import SwiftUI

struct TabNavigationView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
            MyPokemons()
                .tabItem {
                    VStack {
                        Image("pokeball-item")
                            .resizable()
                            .renderingMode(.template)
                        Text("My Pokemons")
                    }
                }
        }
    }
}

#Preview {
    TabNavigationView()
}
