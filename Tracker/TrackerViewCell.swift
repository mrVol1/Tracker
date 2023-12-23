//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Eduard Karimov on 23/12/2023.
//

import UIKit

class CustomCategoryTrackerViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y, width: 167, height: 90)
    }

    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        contentView.addSubview(label)
        
        // Установка констрейтов для лейбла
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
        
        // Настройка внешнего вида ячейки
        contentView.backgroundColor = UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 1)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
    
    func configure(with text: String) {
        label.text = text
    }
}

