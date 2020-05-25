//
//  ViewController.swift
//  Quotes
//
//  Created by Nick Nguyen on 4/18/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//


import UIKit

class QuoteCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private lazy var tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()

		QuoteController.shared.fetchQuotes {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView.reloadData()
    }
    
    //MARK:- Privates
    
    private func setUpCollectionView() {
        navigationItem.title = "Programming Quote"
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        collectionView.updateConstraintsIfNeeded()
        collectionView.addGestureRecognizer(tap)
        collectionView.register(QuoteCell.self, forCellWithReuseIdentifier: "QuoteCell")
        collectionView?.isPagingEnabled = true
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        layout?.minimumLineSpacing = 0
    }
    
   private func changeTabBar(hidden:Bool, animated: Bool){
        guard let tabBar = self.tabBarController?.tabBar else { return; }
        if tabBar.isHidden == hidden{ return }
        let frame = tabBar.frame
        let offset = hidden ? frame.size.height : -frame.size.height
        let duration:TimeInterval = (animated ? 0.5 : 0.0)
        tabBar.isHidden = false
        
        UIView.animate(withDuration: duration, animations: {
            tabBar.frame = frame.offsetBy(dx: 0, dy: offset)
        }, completion: { (true) in
            tabBar.isHidden = hidden
        })
    }
    var isTap = false
    
  
    @objc private func handleTap() {
        if !isTap {
            changeTabBar(hidden: true, animated: true)
            isTap = true
        } else {
            changeTabBar(hidden: false, animated: true)
            isTap = false
        }
   
    }
  
    //MARK:- Datasource
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height )
    }
   
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return QuoteController.shared.quotes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuoteCell", for: indexPath) as! QuoteCell
        
		let (quote, isFavorite) = QuoteController.shared.getQuote(at: indexPath.row)

        cell.delegate = self

        cell.loveButton.backgroundColor = isFavorite ? .link: .black
       
        cell.contentTextView.text = [quote.content, quote.author].joined(separator: "\n\n- ")
        
        return cell
        
    }
   
}

extension QuoteCollectionViewController: UNUserNotificationCenterDelegate {
   
    func registerCategories() {
        
        let center = UNUserNotificationCenter.current()
        
        center.delegate = self
        
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground) // foreground: Go to App
        let remind = UNNotificationAction(identifier: "remind", title: "Remind me later", options: .destructive)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show,remind], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "Hello", options: [])
        
        center.setNotificationCategories([category])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
                case UNNotificationDefaultActionIdentifier:
                    //the user swiped to unlock
                    print("Default identifier")
                case "show":
                    print("Show more Information")
                case "remind" :
                break

                default:
                    break
            }
        }
        
        completionHandler()
        
    }
    
}

extension QuoteCollectionViewController : QuoteCellDelegate {
    func didTapSaveButton(for cell: QuoteCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        QuoteController.shared.updateHasBeenFavorite(for: QuoteController.shared.quotes[indexPath.item])
        
        collectionView.reloadData()
        
    }
    
    func didTapShareButton() {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [img ?? "No image"], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.postToFacebook,.postToTwitter]
        print("asdasda")
        present(activityViewController, animated: true, completion: nil)
    }
}
