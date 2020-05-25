//
//  QuoteController.swift
//  Quotes
//
//  Created by Nick Nguyen on 5/3/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import UIKit

class QuoteController {
	static let shared = QuoteController()

	let fileName = "Quotes.plist"

	var persister: Persister? {
		Persister(withFileName: fileName)
	}

    private(set) var quotes: [Quote] = []
    
    private(set) var favoriteQuotes: [String] = []

	private init() {
		loadFromPersistence()
	}

    private func scheduleLocalNotification(body: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.body = body
        content.categoryIdentifier = "alarm"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4000, repeats: false) // Change this one to 86400 to remind 24 hours later.
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
	func fetchQuotes(completion: @escaping () -> Void) {
		Networking.fetchAllQuotes { (quotes, error) in
			if let error = error {
				NSLog("Error fetching qutoes \(error)")
				completion()
				return
			}
			guard let quotes = quotes else { return }
			self.quotes = quotes
            self.scheduleLocalNotification(body: quotes.randomElement()!.content)
			completion()
		}
	}

	func getQuote(at index: Int) -> (quote: Quote, isFavorite: Bool) {
		let quote = quotes[index]
		let isFavorite = favoriteQuotes.contains(quote.id)
		return (quote, isFavorite)
	}

	func getQuote(by id: String) -> Quote? {
        
		for quote in quotes {
			if quote.id == id {
				return quote
			}
		}
		return nil
	}


	// MARK: - Manage persistence
	// SUGGESTION:  Save the favorites as a separate file.
	// To do this each quote would need a permanent, unique ID.
	// It would be the IDs that you would save to the favorites file.
    func updateHasBeenFavorite(for quote: Quote) {
		if let index = favoriteQuotes.firstIndex(of: quote.id) {
			// this means the quote is currently favorited. toggle OFF
			favoriteQuotes.remove(at: index)
		} else {
			// this means the quote is current not favorited. toggle ON
			favoriteQuotes.append(quote.id)
		}

		savePersistence()
    }

	private func loadFromPersistence() {
		guard let persister = persister else { return }
		do {
			favoriteQuotes = try persister.fetch()
		} catch {
			NSLog("Error loading from persistence!: \(error)")
		}
	}

	private func savePersistence() {
		persister?.save(favoriteQuotes)
	}

}
