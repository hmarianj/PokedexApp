//
//  GenderView.swift
//  PokedexApp
//
//  Created by MH on 14/01/2025.
//

import SwiftUI

struct GenderView: View {
    var maleFraction: CGFloat
    
    var body: some View {
        VStack {
            titleSection
            DualProgressBar(fraction: maleFraction)
            HStack {
                percentageSection(imageName: "male-icon", percentage: malePercentageString)
                Spacer()
                percentageSection(imageName: "female-icon", percentage: femalePercentageString)
            }
        }
    }
}

private extension GenderView {
    var malePercentageString: String {
        "\(Int(maleFraction * 100))%"
    }
    
    var femalePercentageString: String {
        "\(Int(((1 - maleFraction) * 100).rounded()))%"
    }
    
    var titleSection: some View {
        Text("Gender")
            .font(.system(.title3, weight: .semibold))
    }
    
    func percentageSection(imageName: String, percentage: String) -> some View {
        HStack {
            imageSection(imageName: imageName)
            Text(percentage)
                .font(.callout)
        }
    }
    
    func imageSection(imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 16, height: 16)
    }
}

#Preview {
    @Previewable @State var fraction = 0.2
    VStack {
        GenderView(maleFraction: fraction)
        Slider(value: $fraction)
    }
    .padding()
}
