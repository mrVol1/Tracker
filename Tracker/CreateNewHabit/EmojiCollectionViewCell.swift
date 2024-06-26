//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Eduard Karimov on 09/05/2024.
//

import Foundation
import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32)
        return label
    }()
    
    private let emojiColorView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emojiColorView)
        contentView.addSubview(emojiLabel)
        
        emojiColorView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiColorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            emojiColorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiColorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiColorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withEmoji emoji: String, colorEmoji: UIColor, colorCornerRadius: Int, isSelectedEmoji: Bool) {
        emojiLabel.text = emoji
        emojiColorView.backgroundColor = isSelectedEmoji ? colorEmoji : .clear
        emojiColorView.layer.cornerRadius = isSelectedEmoji ? CGFloat(colorCornerRadius) : 0
    }
}
