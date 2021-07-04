//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Alaa' Amr Amin on 01/06/2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGameViewModel
        
    var body: some View {
        VStack {
            Text("Memorize \(game.name)!")
                .foregroundColor(.black)
                .font(.largeTitle)
            
            Divider()
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                CardView(card: card, color: game.color)
                    .padding(3)
                    .onTapGesture {
                        game.chooseCard(card)
                    }
            }
            Divider()
            
            VStack(alignment: .leading) {
                Text("Score: \(game.score ?? "0")")
                Button(action: {
                    game.createNewGame()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                        Text("New Game")
                            .foregroundColor(.white)
                    }
                })
                .frame(height: 50.0)
                .padding(.top, 10.0)
            }
            .font(.title2)
        }
        .foregroundColor(game.color)
        .padding(.horizontal, 10.0)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Pie(startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 40))
                    .padding(DrawingConstraints.timerCirclePadding)
                    .opacity(DrawingConstraints.timerCircleOpacity)
                Text(card.content)
                    .rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstraints.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp, color: color)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstraints.fontSize / DrawingConstraints.fontScale)
    }

    private struct DrawingConstraints {
        static let fontSize: CGFloat = 32
        static let fontScale: CGFloat = 0.7
        static let timerCirclePadding: CGFloat = 5
        static let timerCircleOpacity: Double = 0.5
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let viewModel = EmojiMemoryGameViewModel(themeType: ThemeFactory.allCases.randomElement() ?? .toiletries)
            EmojiMemoryGameView(game: viewModel)
        }
    }
}

