//
//  Networking.swift
//  Quotes
//
//  Created by Nick Nguyen on 4/18/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation

class Networking {
    
    var quotes: [Quotes] = []
    
    let baseURL = URL(string: "https://programming-quotes-api.herokuapp.com/quotes/lang/en#")!
    
    func fetchAllQuotes(completion: @escaping ([Quotes],Error?) -> Void) {
        let request = URLRequest(url: baseURL)
     
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            if let err = error {
                print(err.localizedDescription)
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodedQuotes = try decoder.decode([Quotes].self, from: data)
                self.quotes = decodedQuotes
                completion(decodedQuotes,nil)
            } catch {
                print(error)
                return
            }
        }.resume()
    }
    
}
