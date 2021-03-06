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
                return Theme(name: self.rawValue, emojis: ["๐", "๐", "๐", "๐", "๐", "๐", "๐ป", "๐", "๐", "๐", "๐"], numberOfPairsOfEmojisToShow: 11, color: "red")
                
            case .animals:
                return Theme(name: self.rawValue, emojis: ["๐ฑ", "๐ญ", "๐ฐ", "๐ฆ", "๐ปโโ๏ธ", "๐จ", "๐ฆ", "๐ฏ", "๐ฎ", "๐ธ", "๐", "๐", "๐ง", "๐ฃ", "๐ฆ", "๐ฆ"], numberOfPairsOfEmojisToShow: 7, color: "grey")
                
            case .smilies:
                return Theme(name: self.rawValue, emojis: ["๐ค" , "๐คฉ" , "๐" , "๐ซ" , "๐ฅบ" , "๐ค" , "๐คฏ" , "๐คฅ" , "๐" , "๐ฌ" , "๐คข" , "๐คฎ"], numberOfPairsOfEmojisToShow: 12, color: "blue")
                
            case .toiletries:
                let emojis: Set = ["๐ช ", "๐งบ", "๐งป", "๐ฝ", "๐ฐ", "๐ฟ", "๐", "๐๐ป", "๐งผ", "๐ชฅ", "๐ช", "๐งฝ", "๐ชฃ", "๐งด"]
                let numberOfParis = Int.random(in: 1 ..< emojis.count)
                return Theme(name: self.rawValue, emojis: emojis, numberOfPairsOfEmojisToShow: numberOfParis, color: "yellow")
                
            case .shoes:
                let emojis: Set = ["๐ฉด", "๐ฅฟ", "๐ ", "๐ก", "๐ข", "๐", "๐", "๐ฅพ", "๐งฆ"]
                let numberOfParis = Int.random(in: 1 ..< emojis.count)
                return Theme(name: self.rawValue, emojis: emojis, numberOfPairsOfEmojisToShow: numberOfParis, color: "red")
                
            case .food:
                return Theme(name: self.rawValue, emojis: ["๐ฅ", "๐", "๐ญ", "๐", "๐", "๐", "๐ฅ", "๐ฅ", "๐", "๐"], numberOfPairsOfEmojisToShow: 10, color: "orange")
        }
    }
}

