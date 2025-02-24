//
//  DualProgressBar.swift
//  PokedexApp
//
//  Created by MH on 14/01/2025.
//

import SwiftUI

struct DualProgressBar: View {
    var fraction: CGFloat

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * fraction, height: 20)
                    Rectangle()
                        .fill(Color.pink)
                        .frame(width: geometry.size.width * (1 - fraction), height: 20)
                        .offset(x: geometry.size.width * fraction)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 12)
            .background(.green)
            .cornerRadius(16)
        }
    }
}

#Preview {
    DualProgressBar(fraction: 0.34)
}
