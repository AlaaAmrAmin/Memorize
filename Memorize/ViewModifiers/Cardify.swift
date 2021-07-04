//
//  Cardify.swift
//  Memorize
//
//  Created by Alaa' Amr Amin on 29/06/2021.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    var color: Color
    
    func body(content: Content) -> some View {
        ZStack {
            let cardContainer = RoundedRectangle(cornerRadius: DrawingConstraints.cornerRadius)
            let gradient = LinearGradient(gradient: Gradient(colors: [color.opacity(DrawingConstraints.gradientOpacity), color]), startPoint: .top, endPoint: .bottom)
            if isFaceUp {
                cardContainer.foregroundColor(.white)
                cardContainer.strokeBorder(gradient, lineWidth: DrawingConstraints.strokeWidth, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
            else {
                cardContainer
                    .fill(gradient)
            }
            
            content.opacity(isFaceUp ? 1 : 0)
        }
    }
    
    private struct DrawingConstraints {
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
