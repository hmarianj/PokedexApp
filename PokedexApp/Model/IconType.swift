//
//  IconType.swift
//  PokedexApp
//
//  Created by MH on 03/02/2025.
//

import SwiftUI
import UIKit

enum IconType: String {
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    case stellar

    func getColor(callback: @escaping (Color) -> Void) {
        if let uiImage = UIImage(named: iconAssetName) {
            uiImage.getColors { colors in
                if let primary = colors?.background {
                    callback(Color(primary))
                }
            }
        }
    }

    var iconAssetName: String {
        "\(rawValue)-type"
    }
}
