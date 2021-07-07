//
//  Cardify.swift
//  Memorize
//
//  Created by Alaa' Amr Amin on 29/06/2021.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    private var rotation: Double
    let color: Color
    private var isFaceUp: Bool {
        rotation < 90
    }
    
    var animatableData: Double {
        get {
            rotation
        }
        set {
            rotation = newValue
        }
    }
    
    init(isFaceUp: Bool, color: Color) {
        self.rotation = isFaceUp ? 0 : 180
        self.color = color
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let cardContainer = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            let gradient = LinearGradient(gradient: Gradient(colors: [color.opacity(DrawingConstants.gradientOpacity), color]), startPoint: .top, endPoint: .bottom)
            if isFaceUp {
                cardContainer.foregroundColor(.white)
                cardContainer.strokeBorder(gradient, lineWidth: DrawingConstants.strokeWidth, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
            else {
                cardContainer
                    .fill(gradient)
            }
            
            content.opacity(isFaceUp ? 1 : 0)
        }
        .rotation3DEffect(Angle(degrees: rotation), axis: (0, 1, 0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let strokeWidth: CGFloat = 3
        static let gradientOpacity = 0.3
        
    }
}

extension View {
    func cardify(isFaceUp: Bool, color: Color) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, color: color))
    }
}
