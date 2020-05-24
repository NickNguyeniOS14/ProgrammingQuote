//
//  DetailViewController.swift
//  Quotes
//
//  Created by Nick Nguyen on 4/21/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class FavoriteQuoteTableViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
//        QuoteController.shared.loadFromPersistentStore()
        
        navigationItem.title = "Favorites Quotes"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(named: "textColor")
        tableView.tableFooterView = UIView()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        QuoteController.shared.loadFromPersistentStore()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(QuoteController.shared.favoritesQuotes.count)
        return QuoteController.shared.favoritesQuotes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
     
        let quote = QuoteController.shared.favoritesQuotes[indexPath.row]
        cell.textLabel?.text = [quote.content,quote.author].joined(separator: "\n\n\n- ")
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 20)
        cell.textLabel?.numberOfLines = 0
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          
            var quote = QuoteController.shared.favoritesQuotes[indexPath.row]
            QuoteController.shared.removeQuoteFromFavoriteLists(quote: &quote)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
//            QuoteController.shared.updateHasBeenFavorite(for: quote)
            let userInfo : [String: Quotes] = ["quote": quote]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Remove"), object: nil, userInfo: userInfo)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
}
