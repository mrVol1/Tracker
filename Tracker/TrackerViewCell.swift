//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Eduard Karimov on 23/12/2023.
//

import UIKit

class CombinedTrackerViewCell: UICollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelCount: UILabel = {
        let labelCount = UILabel()
        labelCount.textColor = .black
        labelCount.text = "0 дней"
        labelCount.translatesAutoresizingMaskIntoConstraints = false
        return labelCount
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(label)
        addSubview(labelCount)
        addSubview(addButton)

        // Настройте констрейты элементов интерфейса
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])

        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        labelCount.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelCount.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            labelCount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelCount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])

        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        backgroundColor = .white
    }
    
    func configure(with text: String) {
        label.text = text
    }
}


