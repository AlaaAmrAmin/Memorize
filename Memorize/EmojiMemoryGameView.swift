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
                ScrollViewReader { scrollView in
                    Text("Memorize \(game.name)!")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                    
                    Divider()
                    GeometryReader { geometry in
                        ScrollView {
                            let cardWidth = widthThatBestFits(in: geometry.size)
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: cardWidth))], content: {
                                ForEach(game.cards) { card in
                                    CardView(card: card, color: game.color)
                                        .aspectRatio(2/3, contentMode: .fit)
                                        .onTapGesture {
                                            game.chooseCard(card)
                                        }
                                }
                            })
                        }
                    }
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Score: \(game.score ?? "0")")
                        Button(action: {
                            game.createNewGame()
                            DispatchQueue.main.async {
                                scrollView.scrollTo(game.cards[0].id)
                            }
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
            }
            .foregroundColor(game.color)
            .padding(.horizontal, 10.0)
    }
    
    private func widthThatBestFits(in wholeSize: CGSize) -> CGFloat {
        let spacing: CGFloat = 3
        var numberOfCardsPerRow: CGFloat = 2

        while true {
            let numberOfRows = CGFloat(game.cards.count) / numberOfCardsPerRow
            let actualWidth = wholeSize.width - (20) - ((numberOfCardsPerRow - 1) * spacing)
            let actualHeight = wholeSize.height - ((numberOfRows - 1) * spacing)

            let cardWidth = actualWidth / numberOfCardsPerRow
            let cardHeight = (3/2) * cardWidth

            let totalCardsHeight = cardHeight * numberOfRows
            if totalCardsHeight <= actualHeight {
                return cardWidth
            }
            numberOfCardsPerRow += 1
        }
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
        static let cornerRadius: CGFloat = 20
        static let strokeWidth: CGFloat = 3
        static let gradientOpacity = 0.3
        static let fontScale: CGFloat = 0.8
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

