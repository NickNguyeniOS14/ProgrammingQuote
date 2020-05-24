//
//  QuoteCell.swift
//  Quotes
//
//  Created by Nick Nguyen on 4/18/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

protocol QuoteCellDelegate: class {
    func didTapShareButton()
    func didTapSaveButton(for cell:QuoteCell)
}

class QuoteCell: UICollectionViewCell {
    
    weak var delegate: QuoteCellDelegate?
    
    let view : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "backgroundColor")
        return view
    }()
    
    let contentTextView : UITextView = {
       let content = UITextView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.isSelectable = false
        content.font = UIFont(name: "Avenir Next", size: 30)
        content.isScrollEnabled = true
        content.isEditable = false
        content.scrollsToTop = true
        content.textColor = UIColor(named: "textColor")
        content.textAlignment = .left
        return content
    }()
    
    
    lazy var loveButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(systemName: "heart",withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
        bt.tintColor = UIColor(named: "backgroundColor")
        bt.layer.masksToBounds = true
        bt.clipsToBounds = true
        bt.layer.cornerRadius = bt.bounds.size.width / 2
        bt.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        bt.backgroundColor = UIColor(named: "textColor")
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()
    
    @objc func addToFavorites() {
        
        delegate?.didTapSaveButton(for: self)
       
    }
    lazy var shareButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(systemName: "square.and.arrow.up",withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
        bt.tintColor = UIColor(named: "backgroundColor")
        bt.layer.masksToBounds = true
        bt.clipsToBounds = true
        bt.layer.cornerRadius = bt.bounds.size.width / 2
        bt.addTarget(self, action: #selector(showActivityView), for: .touchUpInside)
        bt.backgroundColor = UIColor(named: "textColor")
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()
  
    @objc func showActivityView() {
        
        delegate?.didTapShareButton()
    }
    
    lazy var stackView: UIStackView = {
       let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .fill
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 10
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(view)
        view.addSubview(contentTextView)
        view.addSubview(stackView)
        view.addSubview(shareButton)
        
        stackView.addArrangedSubview(shareButton)
        stackView.addArrangedSubview(loveButton)

      
        NSLayoutConstraint.activate([
            
            view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,constant: 32),
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: 32),
            view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,constant: -32),
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,constant: -32),
        
            
            contentTextView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            contentTextView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contentTextView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            contentTextView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6),
            
            
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -60),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -30),
           
            shareButton.widthAnchor.constraint(equalToConstant: 40),
            shareButton.heightAnchor.constraint(equalToConstant: 40),
            loveButton.widthAnchor.constraint(equalToConstant: 40),
            loveButton.heightAnchor.constraint(equalToConstant: 40)

            
        ])
    
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var quote: Quotes? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let quote = quote else { return }
        loveButton.backgroundColor = quote.isFavorite ? .red : .black
        contentTextView.text = [quote.content,quote.author].joined(separator: "\n\n- ")
       
    }
   
}
