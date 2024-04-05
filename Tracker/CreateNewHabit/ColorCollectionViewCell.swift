//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Eduard Karimov on 05/04/2024.
//

import Foundation
import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    var colorView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)
        
        // Установите constraints для colorView, чтобы она заполняла ячейку
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(withColor color: UIColor) {
        colorView.backgroundColor = color
    }
}
