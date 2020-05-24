//
//  ViewController.swift
//  Quotes
//
//  Created by Nick Nguyen on 4/18/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//


import UIKit

class QuoteCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, QuoteCellDelegate {
    
    func didTapSaveButton(for cell: QuoteCell) {
        
        let index = collectionView.indexPath(for: cell)!.item
        
        internalQuotes[index].isFavorite.toggle()
        print(internalQuotes[index].isFavorite)
       
        if internalQuotes[index].isFavorite == true {
            QuoteController.shared.addQuoteToFavoriteLists(quote: &internalQuotes[index])
        } else {
            QuoteController.shared.removeQuoteFromFavoriteLists(quote: &internalQuotes[index])
        }
        
        
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
    
    
    var internalQuotes: [Quotes] = []
    private let netWorking = Networking()
    
    //MARK:- Life Cycle
    @objc func updateFavoriteButtonColor(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        var quote  = userInfo["quote"] as! Quotes
        print(quote)
        print(internalQuotes.firstIndex(of: quote))
    }
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        collectionView.updateConstraintsIfNeeded()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        collectionView.addGestureRecognizer(tap)
        
        navigationItem.title = "Programming Quote"
        
        
        collectionView.register(QuoteCell.self, forCellWithReuseIdentifier: "QuoteCell")
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoriteButtonColor), name: NSNotification.Name("Remove"), object: nil)
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        layout?.minimumLineSpacing = 0
        collectionView?.isPagingEnabled = true
        
        
       netWorking.fetchAllQuotes { (quotes, error) in
        guard error == nil else { fatalError("Error fetching Quotes")}
            DispatchQueue.main.async {
                self.internalQuotes = quotes
                
                self.scheduleLocal(body: quotes.randomElement()!.content)
                self.collectionView.reloadData()
            }
     
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    
    
    func changeTabBar(hidden:Bool, animated: Bool){
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
    private func scheduleLocal(body: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.body = body
        content.categoryIdentifier = "alarm"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // Change this one to 86400 to remind 24 hours later.
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
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
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height - 40)
    }
   
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return internalQuotes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuoteCell", for: indexPath) as! QuoteCell
        
        let quote = internalQuotes  [indexPath.row]
        cell.delegate = self
        cell.quote = quote
     
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
