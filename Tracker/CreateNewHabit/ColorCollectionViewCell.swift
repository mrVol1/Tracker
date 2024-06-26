//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Eduard Karimov on 05/04/2024.
//

import Foundation
import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    private let contentViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        return view
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(contentViewContainer)
        contentViewContainer.addSubview(borderView)
        borderView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            contentViewContainer.widthAnchor.constraint(equalToConstant: 46),
            contentViewContainer.heightAnchor.constraint(equalToConstant: 46),
            contentViewContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentViewContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            borderView.widthAnchor.constraint(equalToConstant: 46),
            borderView.heightAnchor.constraint(equalToConstant: 46),
            borderView.centerXAnchor.constraint(equalTo: contentViewContainer.centerXAnchor),
            borderView.centerYAnchor.constraint(equalTo: contentViewContainer.centerYAnchor),
            
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: borderView.centerYAnchor)
        ])
    }
    
    func configure(withColor color: UIColor, isSelectedColor: Bool) {
        colorView.backgroundColor = color
        borderView.layer.borderColor = isSelectedColor ? color.cgColor : UIColor.clear.cgColor
    }
}
