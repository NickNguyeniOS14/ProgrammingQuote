//
//  Quotes.swift
//  Quotes
//
//  Created by Nick Nguyen on 4/18/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation

struct Quotes: Codable, Equatable,Comparable {
    static func < (lhs: Quotes, rhs: Quotes) -> Bool {
        return lhs.author < rhs.author
    }
   
    let content: String
    let author: String
    var isFavorite = false
    
    enum CodingKeys: String,CodingKey {
        case content = "en"
        case author = "author"
    }
    
}
