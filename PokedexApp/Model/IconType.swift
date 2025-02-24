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
        if let uiImage = UIImage(named: iconType) {
            uiImage.getColors { colors in
                if let primary = colors?.background {
                    callback(Color(primary))
                }
            }
        }
    }

    var iconType: String {
        switch self {
        case .normal:
            "normal-type"
        case .fighting:
            "fighting-type"
        case .flying:
            "flying-type"
        case .poison:
            "poison-type"
        case .ground:
            "ground-type"
        case .rock:
            "rock-type"
        case .bug:
            "bug-type"
        case .ghost:
            "ghost-type"
        case .steel:
            "steel-type"
        case .fire:
            "fire-type"
        case .water:
            "water-type"
        case .grass:
            "grass-type"
        case .electric:
            "electric-type"
        case .psychic:
            "psychic-type"
        case .ice:
            "ice-type"
        case .dragon:
            "dragon-type"
        case .dark:
            "rock-type"
        case .fairy:
            "fairy-type"
        case .stellar:
            "stellar-type"
        }
    }
}
