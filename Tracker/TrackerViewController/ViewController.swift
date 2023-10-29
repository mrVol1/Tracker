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
        
        //Создание контейнера для даты
        let container=UIDatePicker()
        view.addSubview(container)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -789),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 222)
        ])
        
        //создание лейбла "Трекеры"
        
        let label = UILabel()
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
        }
        
        guard let customFont = UIFont(name: "SFProDisplay-Bold", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "SF-Pro-Display-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        label.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(34)
        label.textColor = .black
        label.text = "Трекеры"
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 32),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        //добавление поиска
        let search = UISearchBar()
        search.placeholder = "Поиск"
        search.tintColor = .separator.cgColor(red: 0, green: 0, blue: 0, alpha: 0)
        search.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
        view.addSubview(search)
        
        search.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            search.bottomAnchor.constraint(equalTo: label.safeAreaLayoutGuide.bottomAnchor, constant: 54),
            search.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            search.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

