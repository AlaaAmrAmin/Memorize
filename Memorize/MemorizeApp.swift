//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Alaa' Amr Amin on 01/06/2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            let viewModel = EmojiMemoryGameViewModel(themeType: ThemeFactory.allCases.randomElement() ?? .toiletries)
            EmojiMemoryGameView(game: viewModel)
        }
    }
}

