//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Eduard Karimov on 29/10/2023.
//

import UIKit

class TrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let grayColor = UIColorsForProject()
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord]
    var newCategories: [Tracker]
    private let tableViewTrackers = UITableView()
    var tableViewHeightAnchor: NSLayoutConstraint?
    var selectedCategoryLabel: String?
    let search = UISearchTextField()
    let nameForLabelCategory = UILabel()
    let label = UILabel()
    
    let labelCount: UILabel = {
        let labelCount = UILabel()
        labelCount.textColor = .black
        labelCount.text = "0 дней"
        labelCount.translatesAutoresizingMaskIntoConstraints = false
        return labelCount
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 1)
        button.widthAnchor.constraint(equalToConstant: 34).isActive = true
        button.heightAnchor.constraint(equalToConstant: 34).isActive = true
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        
        loadCategories()
        
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
        search.placeholder = "Поиск"
        view.addSubview(search)
        
        search.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            search.heightAnchor.constraint(equalToConstant: 36),
            search.topAnchor.constraint(equalTo: label.safeAreaLayoutGuide.topAnchor, constant: 48),
            search.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            search.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    @objc func buttonAction() {
        let createHabbit = NewHabitController()
        let createHabbitNavigationController = UINavigationController(rootViewController: createHabbit)
        present(createHabbitNavigationController, animated: true, completion: nil)
    }
    
    func loadCategories() {
        if let selectedLabel = selectedCategoryLabel {
            categories = [TrackerCategory(label: selectedLabel, trackerMassiv: [])]
            newCategories = [Tracker(id: 1, name: selectedLabel, color: "", emodji: "", timetable: "")]
            
            //Добавление заголовка
            let customFontBoldMidle = UIFont(name: "SFProDisplay-Medium", size: 19)
            nameForLabelCategory.textColor = .black
            nameForLabelCategory.text = "Домашний уют"
            nameForLabelCategory.font = UIFontMetrics.default.scaledFont(for: customFontBoldMidle ?? UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.bold)).withSize(19)
            view.addSubview(nameForLabelCategory)
            
            nameForLabelCategory.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                nameForLabelCategory.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 148),
                nameForLabelCategory.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
            ])
            
            // создание таблицы
            tableViewTrackers.delegate = self
            tableViewTrackers.dataSource = self
            tableViewTrackers.register(CustomCategoryTrackerViewCell.self, forCellReuseIdentifier: "cell")
            tableViewTrackers.separatorStyle = .none
            view.addSubview(tableViewTrackers)
            
            // создание констрейтов для таблицы
            tableViewTrackers.translatesAutoresizingMaskIntoConstraints = false
            tableViewHeightAnchor = tableViewTrackers.heightAnchor.constraint(equalToConstant: newCategories.isEmpty ? 0 : 90)
            tableViewHeightAnchor?.isActive = true
            
            
            NSLayoutConstraint.activate([
                tableViewTrackers.topAnchor.constraint(equalTo: nameForLabelCategory.bottomAnchor, constant: 12),
                tableViewTrackers.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                tableViewTrackers.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ])
            
            //Настройка констрейтов счетчика
            view.addSubview(labelCount)
            NSLayoutConstraint.activate([
                labelCount.topAnchor.constraint(equalTo: tableViewTrackers.bottomAnchor, constant: 20),
                labelCount.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                labelCount.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ])
            
            //Настройка констрейтов плюса
            view.addSubview(plusButton)
            plusButton.addTarget(self, action: #selector(plusButtonAction), for: .touchUpInside)
            NSLayoutConstraint.activate([
                plusButton.topAnchor.constraint(equalTo: tableViewTrackers.bottomAnchor, constant: 12),
                plusButton.leftAnchor.constraint(equalTo: labelCount.leftAnchor, constant: 135),
            ])
        } else {
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
        tableViewTrackers.reloadData()
    }
    
    // MARK: - table settings
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCategoryTrackerViewCell
        cell.layoutIfNeeded()
        
        if !newCategories.isEmpty {
            let firstCategory = newCategories[0]
            cell.configure(with: firstCategory.name)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newCategories.count
    }
    
    var isButtonPressed = false

    @objc func plusButtonAction() {
        if isButtonPressed {
            plusButton.setTitle("+", for: .normal)
            plusButton.setTitleColor(.white, for: .normal)
            plusButton.backgroundColor = UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 1)
            plusButton.layer.cornerRadius = 17

            plusButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
            plusButton.heightAnchor.constraint(equalToConstant: 34).isActive = true

            plusButton.alpha = 1.0

            if let currentCount = Int(labelCount.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ?? "0") {
                labelCount.text = "0 дней"
            }
        } else {
            plusButton.setTitle("✓", for: .normal)
           plusButton.alpha = 0.3
            if let currentCount = Int(labelCount.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ?? "0") {
                labelCount.text = "\(currentCount + 1) дней"
            }
        }
        isButtonPressed = !isButtonPressed // Переключение значения isButtonPressed
    }
}




