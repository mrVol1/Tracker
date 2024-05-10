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
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32)
        return label
    }()
    
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
        
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        colorView.layer.cornerRadius = 8
        
        contentView.addSubview(colorLabel)
    }
    
    func configure(withColor color: UIColor) {
        colorView.backgroundColor = color
    }
    
    func configureColor(withColor color: String) {
        colorLabel.text = color
    }
}
