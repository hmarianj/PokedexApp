//
//  ListView.swift
//  PokedexApp
//
//  Created by MH on 07/01/2025.
//

import SwiftUI
import UIImageColors

struct CardView: View {
    
    @State private var backgroundColor: Color = Color.cyan.opacity(0.4)
    private static var colorCache = NSCache<NSString, UIColor>() // Caché para colores
    let imageUrl: String
    let name: String
    let id: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                titleSection
                numberIDSection
                Spacer() // TODO: check this in preview
            }
        }
        .frame(maxWidth: .infinity, minHeight: 90 ,alignment: .leading)
        .padding()
        .background {
            cardImageBackground
        }
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
    }
}

private extension CardView {
    var titleSection: some View {
        Text(name.capitalized)
            .font(.system(.title2, weight: .bold))
            .foregroundStyle(.white)
            .multilineTextAlignment(.leading)
            .shadow(radius: 2)
    }
    
    var numberIDSection: some View {
        Text("Nº\(String(format: "%03d", id))")
            .font(.system(.caption2, weight: .semibold))
            .foregroundStyle(.gray)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(.white)
            .cornerRadius(16)
    }
    
    var pokeballImageBackground: some View {
        Image("pokeball-bg")
            .resizable()
            .frame(width: 140, height: 140)
            .offset(x: 30)
    }
    
    var cardImageBackground: some View {
        HStack {
            Spacer()
            ZStack(alignment: .trailingFirstTextBaseline) {
                pokeballImageBackground
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .scaleEffect(x: 1.5, y: 1.5)
                        .task {
                            extractColors(from: image.asUIImage())

                        }
                } placeholder: {
                    ProgressView()
                }
                .padding(.bottom, 4)
            }
        }
        .background(backgroundColor)
    }
    
    private func extractColors(from image: UIImage) {
           let cacheKey = NSString(string: imageUrl)
           
           // Verificar si el color ya está en caché
           if let cachedColor = Self.colorCache.object(forKey: cacheKey) {
               backgroundColor = Color(cachedColor)
               return
           }
           
           // Procesar en segundo plano
           DispatchQueue.global(qos: .userInitiated).async {
               if let colors = image.getColors() {
                   
                   if let primaryColor = colors.background {
                       // Guardar en caché
                       Self.colorCache.setObject(primaryColor, forKey: cacheKey)
                       
                       // Actualizar en el hilo principal
                       DispatchQueue.main.async {
                           withAnimation {
                               backgroundColor = Color(primaryColor)
                           }
                       }
                   }
               }
           }
       }
}


#Preview {
    HStack {
        CardView(
            imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png",
            name: "Pokemon",
            id: 007
        )
        .fixedSize(horizontal: false, vertical: true)
        CardView(
            imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/8.png",
            name: "Pokemon",
            id: 008
        )
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding()
    
}

extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
 // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
        controller.view.backgroundColor = .clear
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
