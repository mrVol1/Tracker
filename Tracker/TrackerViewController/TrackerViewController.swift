//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Eduard Karimov on 29/10/2023.
//

import UIKit

class TrackerViewController: UIViewController {
    let grayColor = UIColorsForProject()
    var categories: [TrackerCategory]
    var completedTrackers: [TrackerRecord]
    var newCategories: [Tracker]
    
    init(categories: [TrackerCategory], completedTrackers: [TrackerRecord], newCategories: [Tracker]) {
        self.categories = categories
        self.completedTrackers = completedTrackers
        self.newCategories = newCategories
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.categories = []
        self.completedTrackers = [] 
        self.newCategories = []
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //Создание кнопки "+"
        let plusButton = UIButton()
        plusButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
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
        let container = UIDatePicker()
        container.datePickerMode = .date
        view.addSubview(container)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 222)
        ])
        
        //создание лейбла "Трекеры"
        
        let label = UILabel()
        
        let customFontBold = UIFont(name: "SFProDisplay-Bold", size: UIFont.labelFontSize)
        
        label.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)).withSize(34)
        label.textColor = .black
        label.text = "Трекеры"
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 48),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        //добавление поиска
        let search = UISearchTextField()
        search.placeholder = "Поиск"
        view.addSubview(search)
        
        search.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            search.heightAnchor.constraint(equalToConstant: 36),
            search.topAnchor.constraint(equalTo: label.safeAreaLayoutGuide.topAnchor, constant: 48),
            search.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            search.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        //добавление картинки
        guard let defaultImage = UIImage(named: "1") else { return }
        let imageView = UIImageView(image: defaultImage)
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        //добавление надписи
        
        let defultLabel = UILabel()
        
        defultLabel.textColor = .black
        defultLabel.text = "Что будем отслеживать?"
        view.addSubview(defultLabel)
        
        defultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            defultLabel.bottomAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.bottomAnchor, constant: 28),
            defultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func buttonAction() {
        let createHabbit = NewHabitController()
        let createHabbitNavigationController = UINavigationController(rootViewController: createHabbit)
        present(createHabbitNavigationController, animated: true, completion: nil)
    }
}


