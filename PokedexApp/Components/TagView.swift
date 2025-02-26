//
//  TagView.swift
//  PokedexApp
//
//  Created by MH on 07/01/2025.
//

import SwiftUI
import UIImageColors

struct TagView: View {
    @State private var backgroundColor: Color = .gray.opacity(0.4)
    let content: Content
    let style: Style

    var body: some View {
        HStack {
            Image(content.iconType?.iconAssetName ?? "")
                .resizable()
                .scaledToFit()
                .frame(width: style.width, height: style.height)
                .padding(style.iconPadding)
                .background(.white)
                .cornerRadius(24)
            Text(content.type.capitalized)
                .font(style.fontSize)
                .foregroundStyle(.white)
        }
        .onAppear {
            loadBackgroundColor()
        }
        .padding(.horizontal, style.horizontalPadding)
        .padding(.vertical, style.verticalPadding)
        .background(backgroundColor)
        .cornerRadius(28)
    }
}

extension TagView {
    struct Content {
        let type: String
        var iconType: IconType? {
            IconType(rawValue: type.lowercased())
        }
    }

    struct Style {
        let fontSize: Font
        let width: CGFloat
        let height: CGFloat
        let iconPadding: CGFloat
        let horizontalPadding: CGFloat
        let verticalPadding: CGFloat

        static let standard = Style(
            fontSize: .system(.subheadline, weight: .bold),
            width: 14,
            height: 14,
            iconPadding: 2,
            horizontalPadding: 6,
            verticalPadding: 4
        )

        static let category = Style(
            fontSize: .system(.title3, weight: .bold),
            width: 18,
            height: 18,
            iconPadding: 4,
            horizontalPadding: 10,
            verticalPadding: 6
        )
    }
}

private extension TagView {
    func loadBackgroundColor() {
        if let iconType = content.iconType {
            iconType.getColor { color in
                backgroundColor = color
            }
        }
    }
}

#Preview {
    VStack {
        TagView(
            content: TagView.Content(type: "Water"),
            style: TagView.Style.standard
        )
        TagView(
            content: TagView.Content(type: "Fire"),
            style: TagView.Style.category
        )
        TagView(
            content: TagView.Content(type: "Electric"),
            style: TagView.Style.category
        )
    }
    .padding()
}
