//
//  CardView.swift
//  Memorize
//
//  Created by Alaa' Amr Amin on 07/07/2021.
//

import SwiftUI

struct CardView: View {
    let card: MemoryGame<String>.Card
    let color: Color
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 270), endAngle: Angle(degrees: (1-animatedBonusRemaining) * 360 - 90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(Animation.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    }
                    else {
                        Pie(startAngle: Angle(degrees: 270), endAngle: Angle(degrees: (1-card.bonusRemaining) * 360 - 90))
                    }
                }
                .padding(DrawingConstants.timerCirclePadding)
                .opacity(DrawingConstants.timerCircleOpacity)
                
                Text(card.content)
                    .padding()
                    .rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp, color: color)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontSize: CGFloat = 32
        static let fontScale: CGFloat = 0.7
        static let timerCirclePadding: CGFloat = 5
        static let timerCircleOpacity: Double = 0.5
        
    }
}


//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
