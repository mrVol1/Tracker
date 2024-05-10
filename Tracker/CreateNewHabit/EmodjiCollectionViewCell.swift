//
//  EmodjiCollectionViewCell.swift
//  Tracker
//
//  Created by Eduard Karimov on 09/05/2024.
//

import Foundation
import UIKit

class EmodjiCollectionViewCell: UICollectionViewCell {
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32)
        return label
    }()
    
    private let emodjiColorView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emodjiColorView)
        contentView.addSubview(emojiLabel)
        
        emodjiColorView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emodjiColorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            emodjiColorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emodjiColorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emodjiColorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withEmoji emoji: String, colorEmodji: UIColor, colorCornerRadius: Int, isSelectedEmodji: Bool) {
        emojiLabel.text = emoji
        emodjiColorView.backgroundColor = isSelectedEmodji ? colorEmodji : .clear
        emodjiColorView.layer.cornerRadius = isSelectedEmodji ? CGFloat(colorCornerRadius) : 0
    }
}
