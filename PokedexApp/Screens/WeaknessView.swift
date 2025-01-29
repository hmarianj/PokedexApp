//
//  WeaknessView.swift
//  PokedexApp
//
//  Created by MH on 15/01/2025.
//

import SwiftUI

struct WeaknessView: View {
    var body: some View {
        VStack {
            titleSection
                HStack(spacing: 20) {
                    TagView(content: TagView.Content(type: "Water"), style: TagView.Style.category)
                    TagView(content: TagView.Content(type: "Water"), style: TagView.Style.category)
                }
            HStack(spacing: 20) {
                TagView(content: TagView.Content(type: "Water"), style: TagView.Style.category)
                TagView(content: TagView.Content(type: "Water"), style: TagView.Style.category)
            }
            }
        }
    }

private extension WeaknessView {
    
    var titleSection: some View {
        Text("Weaknesses")
            .padding(.vertical)
            .font(.system(.title2, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    WeaknessView()
}
