//
//  ErrorView.swift
//  PokedexApp
//
//  Created by MH on 03/02/2025.
//

import SwiftUI

struct ErrorView: View {
    var onRetry: () -> Void
    
    var body: some View {
        VStack {
            Text("Algo salio mal")
            Button {
                onRetry()
            } label: {
                Text("Reintentar")
            }
        }
    }
}

#Preview {
    ErrorView {
        print("Reintenté")
    }
}
