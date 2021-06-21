//
//  MemoryGame.swift
//  Memorize
//
//  Created by Alaa' Amr Amin on 13/06/2021.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private(set) var score = 0
    private var previouslySelectedCardIndex: Int? {
        let faceUpCardsIndices = cards.indices.filter({ cards[$0].isFaceUp })
        return faceUpCardsIndices.count == 1 ? faceUpCardsIndices.first : nil
    }
    private var lastFlippingDate: Date?
    
    struct Card: Identifiable {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    seenCount += 1
                }
            }
        }
        var isMatched = false
        var seenCount = 0
        let content: CardContent
        var id: Int
    }
    
    init(numberOfPairsOfCards: Int, cardContent: ((Int) -> (CardContent))) {
        cards = [Card]()
        for i in 0 ..< numberOfPairsOfCards {
            let content = cardContent(i)
            cards.append(Card(content: content, id: i * 2))
            cards.append(Card(content: content, id: (i * 2) + 1))
        }
        cards.shuffle()
    }
    
    mutating func chooseCard(_ card: Card) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        guard !cards[index].isMatched else { return }
        guard !cards[index].isFaceUp else { return }
        
        if let previouslySelectedCardIndex = previouslySelectedCardIndex {
            cards[index].isFaceUp = true
            let previouslySelectedCard = cards[previouslySelectedCardIndex]
            if card.content == previouslySelectedCard.content {
                cards[index].isMatched = true
                cards[previouslySelectedCardIndex].isMatched = true
                score += (2 * calculateSpeedBonus())
            }
            else {
                [index, previouslySelectedCardIndex].forEach {
                    if cards[$0].seenCount > 1 {
                        score -= 1
                    }
                }
            }
        }
        else {
            for iterator in cards.indices {
                cards[iterator].isFaceUp = false
            }
            cards[index].isFaceUp = true
        }
        
        lastFlippingDate = Date()
    }
    
    private func calculateSpeedBonus() -> Int {
        let secondsBetweenSelections = Int(-lastFlippingDate!.timeIntervalSinceNow) % 60
        return Int(max(5 - secondsBetweenSelections, 1))
    }
}

