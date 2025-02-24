//
//  PokeballButton.swift
//  PokedexApp
//
//  Created by MH on 04/02/2025.
//

import Foundation
import SwiftUI

struct PokeballButton: View {
    
    var isCaptured: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(isCaptured ? "pokeball-close" : "pokeball-open")
                .resizable()
                .frame(width: 48, height: 48)
        }
    }
}

#Preview {
    PokeballButton(isCaptured: true) {
        print("Captured")
    }
}
