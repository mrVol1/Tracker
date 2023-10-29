//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Eduard Karimov on 29/10/2023.
//

import UIKit

class TrackerViewController: UIViewController {
    let grayColor = UIColorsForProject()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //Создание кнопки "+"
        let plusButton = UIButton()
        plusButton.setImage(UIImage(named: "Add tracker"), for: .normal)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.setTitleColor(.black, for: .normal)
        view.addSubview(plusButton)
        
        //Настройка констрейтов для кнопки плюс
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6)
        ])
        
        //Создание контейнера под дату
        let container = UIView()
        container.frame = CGRect(origin: CGPoint(), size: CGSize(width: 77, height: 34))
        container.backgroundColor = grayColor.grayColor
        view.addSubview(container)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        //создание даты
        let labelData = UILabel()
        labelData.text = "24.01.2024"
        labelData.textColor = .black
        labelData.font = UIFont(name: "SF Pro", size: 17)
        view.addSubview(labelData)
        
        labelData.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelData.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            labelData.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5.5)
        ])
    }
}

