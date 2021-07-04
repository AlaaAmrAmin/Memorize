//
//  Theme.swift
//  Memorize
//
//  Created by Alaa' Amr Amin on 13/06/2021.
//

import Foundation

struct Theme {
    let name: String
    let emojis: Set<String>
    let numberOfPairsOfEmojisToShow: Int
    let color: String
    
    init(name: String, emojis: Set<String>, numberOfPairsOfEmojisToShow: Int? = nil, color: String) {
        self.name = name
        self.emojis = emojis
        if let numberOfPairs = numberOfPairsOfEmojisToShow, numberOfPairs <= emojis.count {
            self.numberOfPairsOfEmojisToShow = numberOfPairs
        }
        else {
            self.numberOfPairsOfEmojisToShow = emojis.count
        }
        self.color = color
    }
}

enum ThemeFactory: String, CaseIterable {
    case vehicles
    case animals
    case smilies
    case toiletries
    case shoes
    case food
    
    func createTheme() -> Theme {
        switch self {
            case .vehicles:
                return Theme(name: self.rawValue, emojis: ["🚕", "🚙", "🚌", "🚓", "🚑", "🚒", "🛻", "🚛", "🚜", "🚔", "🚘"], numberOfPairsOfEmojisToShow: 11, color: "red")
                
            case .animals:
                return Theme(name: self.rawValue, emojis: ["🐱", "🐭", "🐰", "🦊", "🐻‍❄️", "🐨", "🦁", "🐯", "🐮", "🐸", "🐒", "🐔", "🐧", "🐣", "🦆", "🦉"], numberOfPairsOfEmojisToShow: 7, color: "grey")
                
            case .smilies:
                return Theme(name: self.rawValue, emojis: ["🤓" , "🤩" , "😖" , "😫" , "🥺" , "😤" , "🤯" , "🤥" , "🙄" , "😬" , "🤢" , "🤮"], numberOfPairsOfEmojisToShow: 12, color: "blue")
                
            case .toiletries:
                let emojis: Set = ["🪠", "🧺", "🧻", "🚽", "🚰", "🚿", "🛁", "🛀🏻", "🧼", "🪥", "🪒", "🧽", "🪣", "🧴"]
                let numberOfParis = Int.random(in: 1 ..< emojis.count)
                return Theme(name: self.rawValue, emojis: emojis, numberOfPairsOfEmojisToShow: numberOfParis, color: "yellow")
                
            case .shoes:
                let emojis: Set = ["🩴", "🥿", "👠", "👡", "👢", "👞", "👟", "🥾", "🧦"]
                let numberOfParis = Int.random(in: 1 ..< emojis.count)
                return Theme(name: self.rawValue, emojis: emojis, numberOfPairsOfEmojisToShow: numberOfParis, color: "red")
                
            case .food:
                return Theme(name: self.rawValue, emojis: ["🥐", "🍗", "🌭", "🍔", "🍟", "🍕", "🥗", "🥘", "🍜", "🍝"], numberOfPairsOfEmojisToShow: 10, color: "orange")
        }
    }
}

