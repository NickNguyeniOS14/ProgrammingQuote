//
//  DetailViewController.swift
//  Quotes
//
//  Created by Nick Nguyen on 4/21/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class FavoriteQuoteTableViewController : UITableViewController {
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(named: "textColor")
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "Favorites Quotes"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadSections(IndexSet(integer: 0), with: .fade) // animate reload data
    }
    
    //MARK:- Datasource
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("favorite quotes is \(QuoteController.shared.favoriteQuotes.count)")
        return QuoteController.shared.favoriteQuotes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
     
        let favoriteID = QuoteController.shared.favoriteQuotes[indexPath.row]
		guard let quote = QuoteController.shared.getQuote(by: favoriteID) else {
			cell.textLabel?.text = "Quote not found!"
			return cell
		}
        cell.textLabel?.text = [quote.content, quote.author].joined(separator: "\n\n\n- ")
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 20)
        cell.textLabel?.numberOfLines = 0
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let quoteID = QuoteController.shared.favoriteQuotes[indexPath.row]
			guard let quote = QuoteController.shared.getQuote(by: quoteID) else { return }
            QuoteController.shared.updateHasBeenFavorite(for: quote)
            tableView.deleteRows(at: [indexPath], with: .fade)
        
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
}
