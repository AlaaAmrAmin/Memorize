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
                let speedBonus = speedBonus(for: cards[previouslySelectedCardIndex]) + speedBonus(for: cards[index])
                score += (2 * speedBonus)
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
    }
    
    mutating func shuffleCards() {
        cards.shuffle()
    }
    
    private func speedBonus(for card: Card) -> Int {
        card.hasEarnedBonus ? Int(card.bonusRemaining) : 0
    }
}

extension MemoryGame {
    
    struct Card: Identifiable {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        
        var seenCount = 0
        let content: CardContent
        var id: Int
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
