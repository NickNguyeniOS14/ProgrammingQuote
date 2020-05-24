//
//  QuoteController.swift
//  Quotes
//
//  Created by Nick Nguyen on 5/3/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation

class QuoteController
{
    static let shared = QuoteController()
    
    private var quoteURL: URL? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "Quotes.plist"
        return documentDirectory?.appendingPathComponent(fileName)
    }
    
    
    var favoritesQuotes: [Quotes] = []
    
    func addQuoteToFavoriteLists( quote:inout Quotes) {
    
        favoritesQuotes.append(quote)
        saveToPersistentStore()
        
    }
    func removeQuoteFromFavoriteLists( quote:inout Quotes) {

        guard let positionToRemove = favoritesQuotes.firstIndex(of:quote) else { return }
        favoritesQuotes.remove(at: positionToRemove)
        saveToPersistentStore()
    }
    
    func updateHasBeenFavorite(for quote: Quotes, at position : Int ) {
        guard let index = favoritesQuotes.firstIndex(of: quote) else { return }
        favoritesQuotes[index].isFavorite = !favoritesQuotes[index].isFavorite
        
        saveToPersistentStore()
    }
    
     func saveToPersistentStore() {
        let plistEncoder = PropertyListEncoder()
        do {
            let quotesData = try plistEncoder.encode(favoritesQuotes)
            guard let fileURL = quoteURL else { return }
            try quotesData.write(to: fileURL)
        } catch let err as NSError {
            print(err.localizedDescription)
        }
    }
    
     func loadFromPersistentStore() {
        do {
            guard let fileURL = quoteURL else { return }
            let quotesData = try Data(contentsOf: fileURL)
            let plistDecoder = PropertyListDecoder()
            self.favoritesQuotes = try plistDecoder.decode([Quotes].self, from: quotesData)
        } catch let err as NSError {
            print(err.localizedDescription)
        }
    }
    
    
}
