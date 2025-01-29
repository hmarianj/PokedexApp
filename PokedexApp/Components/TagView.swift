//
//  TagView.swift
//  PokedexApp
//
//  Created by MH on 07/01/2025.
//

import SwiftUI

struct TagView: View {
    let content: Content
    let style: Style
    
    var body: some View {
        HStack {
            Image(style.iconType)
                .resizable()
                .scaledToFit()
                .frame(width: style.width, height: style.height)
                .padding(style.iconPadding)
                .background(.white)
                .cornerRadius(24)
            Text(content.type)
                .font(style.fontSize)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, style.horizontalPadding)
        .padding(.vertical, style.verticalPadding)
        .background(style.background)
        .cornerRadius(28)
    }
}

// TODO: check that parameters need

extension TagView {
    struct Content {
        let type: String
    }
    
    struct Style {
        let iconType: String
        let fontSize: Font
        let background: Color
        let width: CGFloat
        let height: CGFloat
        let iconPadding: CGFloat
        let horizontalPadding: CGFloat
        let verticalPadding: CGFloat
        
        static let standar = Style(
            iconType: "aqua-type",
            fontSize: .system(.subheadline, weight: .bold),
            background: .cyan.opacity(0.4),
            width: 14,
            height: 14,
            iconPadding: 2,
            horizontalPadding: 6,
            verticalPadding: 4
        )
        
        static let category = Style(
            iconType: "fire-type",
            fontSize: .system(.title3, weight: .bold),
            background: .orange.opacity(0.4),
            width: 24,
            height: 24,
            iconPadding: 8,
            horizontalPadding: 30,
            verticalPadding: 6
        )
    }
}

#Preview {
    VStack {
        TagView(
            content: TagView
                .Content(type: "Water"
            ),
            style: TagView.Style.standar
        )
        TagView(
            content: TagView
                .Content(type: "Water"
            ),
            style: TagView.Style.category
        )
    }
}
