//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Eduard Karimov on 23/12/2023.
//

import UIKit

class TrackerViewCell: UICollectionViewCell {

    // MARK: - closures

    var completion: (() -> Void)?

    // MARK: - consts

    enum Const {
        static let plusButtonSize: CGFloat = 34.0
    }
    
    // MARK: - subview

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelCount: UILabel = {
        let labelCount = UILabel()
        labelCount.textColor = .black
        labelCount.text = "0 дней"
        labelCount.translatesAutoresizingMaskIntoConstraints = false
        return labelCount
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Const.plusButtonSize / 2.0
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup

    private func setupUI() {
        contentView.addSubview(containerView)
        contentView.addSubview(label)
        contentView.addSubview(labelCount)
        contentView.addSubview(addButton)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(colorView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 174),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 90),
            containerView.widthAnchor.constraint(equalToConstant: 240)
        ])
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            emojiLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: containerView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
        ])


        NSLayoutConstraint.activate([
            labelCount.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            labelCount.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 36),
        ])

        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            addButton.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -38),
            addButton.widthAnchor.constraint(equalToConstant: Const.plusButtonSize),
            addButton.heightAnchor.constraint(equalToConstant: Const.plusButtonSize),
        ])
    }
    
    // MARK: - configs

    func configure(with tracker: Tracker, isChecked: Bool, completedDaysCount: Int) {
         label.text = tracker.name
         emojiLabel.text = tracker.emoji
         colorView.backgroundColor = UIColor(hex: tracker.color)
         addButton.backgroundColor = UIColor(hex: tracker.color)
        
         if isChecked {
             addButton.setTitle("✓", for: .normal)
             addButton.alpha = 0.3
         } else {
             addButton.setTitle("+", for: .normal)
             addButton.alpha = 1.0
         }
         labelCount.text = "\(completedDaysCount) дней"
     }

    // MARK: - actions

    @objc func addButtonTapped() {
        completion?()
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
