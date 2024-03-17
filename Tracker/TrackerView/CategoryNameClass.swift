//
//  CategoryNameClass.swift
//  Tracker
//
//  Created by Eduard Karimov on 29/02/2024.
//

import Foundation
import UIKit

class CategoryNameClass: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderReusableView"
    let customFontBoldMidle = UIFont(name: "SFProDisplay-Medium", size: 19)
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        titleLabel.font = UIFontMetrics.default.scaledFont(for: customFontBoldMidle ?? UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.bold) ).withSize(19)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
