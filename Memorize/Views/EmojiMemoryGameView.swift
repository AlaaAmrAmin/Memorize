//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Alaa' Amr Amin on 01/06/2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
    
    @ObservedObject var game: EmojiMemoryGameViewModel
    
    @State private var dealt = Set<Int>()
    @Namespace private var dealingNamespace
    
    var body: some View {
        VStack {
            title
            
            Divider()
            ZStack(alignment: .bottom) {
                gameBody
                deckBody
            }
            Divider()
            
            VStack(alignment: .leading) {
                score
                
                HStack {
                    shuffleButton
                    newGameButton
                }
                .frame(height: 50.0)
                .padding(.top, 10.0)
                
            }
            .font(.title2)
        }
        .foregroundColor(game.color)
        .padding(.horizontal, 10.0)
    }
    
    private var title: some View {
        Text("Memorize \(game.name)!")
            .foregroundColor(.black)
            .font(.largeTitle)
        
    }
    
    private var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            }
            else {
                CardView(card: card, color: game.color)
                    .padding(3)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .onTapGesture {
                        withAnimation {
                            game.chooseCard(card)
                        }
                    }
            }
        }
    }
    
    private var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card, color: game.color)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .zIndex(zIndex(for: card))
            }
        }
        .frame(width: DrawingConstants.deckWidth, height: DrawingConstants.deckHeight)
        .onTapGesture {
            for card in game.cards{
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    private var score: some View {
        Text("Score: \(game.score ?? "0")")
    }
    
    private var shuffleButton: some View {
        Button(action: {
            withAnimation {
                game.shuffle()
            }
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                Text("Shuffle")
                    .foregroundColor(.white)
            }
        })
       
    }
    
    private var newGameButton: some View {
        Button(action: {
            dealt = []
            game.createNewGame()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                Text("New Game")
                    .foregroundColor(.white)
            }
        })
    }
    
    struct DrawingConstants {
        static let dealDuration: Double = 0.3
        static let totalDealDuration: Double = 2
        static let deckHeight: CGFloat = 120
        static let deckWidth: CGFloat = deckHeight * (2/3)
    }
}

extension EmojiMemoryGameView {
    var dealtCards: [Card] {
        game.cards.filter { dealt.contains($0.id) }
    }
    
    private func deal(_ card: Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: Card) -> Animation {
        let cardIndex = game.cards.firstIndex { $0.id == card.id } ?? 0
        let totalDealDuration = min(DrawingConstants.totalDealDuration, DrawingConstants.dealDuration * Double(game.cards.count))
        let delay = Double(cardIndex) * ( totalDealDuration / Double(game.cards.count))
        return Animation.easeInOut(duration: DrawingConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(for card: Card) -> Double {
        -Double(game.cards.firstIndex { $0.id == card.id } ?? 0)
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

