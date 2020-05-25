//
//  Quote.swift
//  Quotes
//
//  Created by Nick Nguyen on 4/18/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation

struct Quote: Codable, Equatable, Comparable {
	static func < (lhs: Quote, rhs: Quote) -> Bool {
		return lhs.author < rhs.author
	}
	let id: String
	let content: String
	let author: String


	enum CodingKeys: String,CodingKey {
		case content = "en"
		case author = "author"
		case id = "_id"
	}
}
