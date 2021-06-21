//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Alaa' Amr Amin on 21/06/2021.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    let items: [Item]
    let aspectRatio: CGFloat
    let content: (Item) -> ItemView
    
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping ((Item) -> ItemView)) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
//            VStack {
                let width: CGFloat = widthThatBestFits(itemsCount: items.count, in: geometry.size, withAspectRatio: aspectRatio)
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    ForEach(items) {
                        content($0).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
            }
//        }
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func widthThatBestFits(itemsCount: Int, in size: CGSize, withAspectRatio aspectRatio: CGFloat) -> CGFloat {
        var numberOfCardsPerRow: CGFloat = 1
        
        repeat {
            let numberOfRows = CGFloat(itemsCount) / numberOfCardsPerRow
            
            let itemWidth = size.width / numberOfCardsPerRow
            let itemHeight = itemWidth / aspectRatio
            
            let totalCardsHeight = itemHeight * numberOfRows
            if totalCardsHeight <= size.height {
                return itemWidth
            }
            numberOfCardsPerRow += 1
        } while numberOfCardsPerRow < CGFloat(itemsCount)
        
        return floor(size.width / numberOfCardsPerRow)
    }
}

//struct AspectVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGrid()
//    }
//}
