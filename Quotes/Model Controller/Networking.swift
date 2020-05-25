//
//  Networking.swift
//  Quotes
//
//  Created by Nick Nguyen on 4/18/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation

enum Networking {
    
    static let baseURL = URL(string: "https://programming-quotes-api.herokuapp.com/quotes/lang/en#")!
    
    
    static func fetchAllQuotes(completion: @escaping ([Quote]?, Error?) -> Void) {
		let request = URLRequest(url: baseURL)
     
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            if let err = error {
                completion(nil, err)
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodedQuotes = try decoder.decode([Quote].self, from: data)
                completion(decodedQuotes, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
}
