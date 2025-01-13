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
        Text(content.description)
            .font(.system(.subheadline, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(content.background)
            .cornerRadius(12)
    }
}

extension TagView {
    struct Content {
        let description: String
        let background: Color
    }
}

#Preview {
    TagView(content: TagView.Content(description: "water", background: .gray))
}
