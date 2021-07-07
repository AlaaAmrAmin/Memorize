//
//  EmojiMemoryGameViewModel.swift
//  Memorize
//
//  Created by Alaa' Amr Amin on 13/06/2021.
//

import Foundation

import SwiftUI

class EmojiMemoryGameViewModel: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    @Published private var model: MemoryGame<String>
    @Published private var theme: Theme
    
    var name: String {
        theme.name
    }
    
    var cards: [Card] {
        return model.cards
    }
    
    var score: String? { model.score > 0 ? "\(model.score)" : nil }
    
    var color: Color {
        switch theme.color {
            case "red": return .red
            case "grey": return .gray
            case "blue": return .blue
            case "yellow": return .yellow
            case "orange": return .orange
            default: return .black
        }
    }
    
    
    init(themeType: ThemeFactory) {
        let theme = themeType.createTheme()
        self.theme = theme
        self.model = Self.createMemoryGame(from: theme)
    }
    
    static func createMemoryGame(from theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
        return MemoryGame(numberOfPairsOfCards: theme.numberOfPairsOfEmojisToShow) { emojis[$0] }
    }
    
    func chooseCard(_ card: Card) {
        model.chooseCard(card)
    }
    
    func createNewGame() {
        guard let theme = ThemeFactory.allCases.randomElement()?.createTheme() else { return }
        
        self.theme = theme
        self.model = Self.createMemoryGame(from: theme)
    }
    
    func shuffle() {
        model.shuffleCards()
    }
}
