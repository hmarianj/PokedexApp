//
//  TagView.swift
//  PokedexApp
//
//  Created by MH on 07/01/2025.
//

import SwiftUI

struct TagView: View {
    let content: Content
    
    var body: some View {
        HStack {
            Image(content.iconType)
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .padding(2)
                .background(.white)
                .cornerRadius(16)
            Text(content.description)
                .font(.system(.subheadline, weight: .bold))
                .foregroundStyle(.gray)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(content.background)
        .cornerRadius(16)
    }
}

extension TagView {
    struct Content {
        let description: String
        let iconType: String
        let background: Color
    }
}

#Preview {
    TagView(content: TagView.Content(description: "Water", iconType: "aqua-type", background: .blue.opacity(0.2)))
}
