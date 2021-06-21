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
                let cardContainer = RoundedRectangle(cornerRadius: DrawingConstraints.cornerRadius)
                if card.isMatched {
                    cardContainer.opacity(0)
                }
                else {
                    let gradient = LinearGradient(gradient: Gradient(colors: [color.opacity(DrawingConstraints.gradientOpacity), color]), startPoint: .top, endPoint: .bottom)
                    if card.isFaceUp {
                        cardContainer.foregroundColor(.white)
                        cardContainer.strokeBorder(gradient, lineWidth: DrawingConstraints.strokeWidth, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        Text(card.content).font(font(using: geometry.size))
                    }
                    else {
                        cardContainer
                            .fill(gradient)
                    }
                }
            }
        }
    }
    
    private func font(using size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstraints.fontScale)
    }
    
    private struct DrawingConstraints {
        static let cornerRadius: CGFloat = 10
        static let strokeWidth: CGFloat = 3
        static let gradientOpacity = 0.3
        static let fontScale: CGFloat = 0.7
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

