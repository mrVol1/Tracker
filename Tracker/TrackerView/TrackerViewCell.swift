//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Eduard Karimov on 23/12/2023.
//

import UIKit

class TrackerViewCell: UICollectionViewCell {
    
    weak var completionDelegate: TrackerCompletionDelegate?
    
    var isChecked = false
    var tracker: Tracker?
    var completedDaysCount = 0
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0x33 / 255.0, green: 0xCF / 255.0, blue: 0x69 / 255.0, alpha: 1.0)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let labelCount: UILabel = {
        let labelCount = UILabel()
        labelCount.textColor = .black
        labelCount.text = "0 дней"
        return labelCount
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0x33 / 255.0, green: 0xCF / 255.0, blue: 0x69 / 255.0, alpha: 1.0)
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "checkmark"))
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        contentView.addSubview(label)
        contentView.addSubview(labelCount)
        contentView.addSubview(addButton)
        contentView.addSubview(checkmarkImageView)

        // Настройка констретов элементов интерфейса
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.isUserInteractionEnabled = true
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 167),
            containerView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ])
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.isUserInteractionEnabled = true
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            addButton.widthAnchor.constraint(equalToConstant: 34),
            addButton.heightAnchor.constraint(equalToConstant: 34),
            addButton.leftAnchor.constraint(equalTo: labelCount.leftAnchor, constant: 130)
        ])
        
        labelCount.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelCount.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 16),
            labelCount.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0)
        ])
        
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkmarkImageView.centerXAnchor.constraint(equalTo: addButton.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with tracker: Tracker) {
        label.text = tracker.name
    }
    
    @objc func addButtonTapped() {
        isChecked.toggle()
        
        if isChecked {
            addButton.setTitle("", for: .normal)
            checkmarkImageView.isHidden = false
            addButton.alpha = 0.3
            completedDaysCount += 1
        } else {
            addButton.setTitle("+", for: .normal)
            checkmarkImageView.isHidden = true
            addButton.alpha = 1.0
            completedDaysCount -= 1
        }
        
        labelCount.text = "\(completedDaysCount) дней"
        
        if let tracker = tracker {
            completionDelegate?.didCompleteTracker(tracker)
        }
    }
}
