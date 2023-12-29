//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Eduard Karimov on 29/10/2023.
//

import UIKit

class TrackerViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as! CombinedTrackerViewCell
        
        let category = newCategories[indexPath.item]
        cell.configure(with: category.name)
        
        return cell
    }
    
    
    let grayColor = UIColorsForProject()
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord]
    var newCategories: [Tracker]
    var selectedCategoryLabel: String?
    let search = UISearchTextField()
    let nameForLabelCategory = UILabel()
    let label = UILabel()
    let customFontBoldMidle = UIFont(name: "SFProDisplay-Medium", size: 19)
    
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
    
    var labelCategory: UILabel {
        let labelCategory = UILabel()
        labelCategory.textColor = .black
        labelCategory.text = selectedCategoryLabel //добавить сюда значение из категории
        labelCategory.font = UIFontMetrics.default.scaledFont(for: customFontBoldMidle ?? UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.bold) ).withSize(19)
        return labelCategory
    }
    
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
    
    private let collectionViewTrackers: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CombinedTrackerViewCell.self, forCellWithReuseIdentifier: "trackerCell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.delegate = self
        
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
        
        container.minimumDate = Date()
        container.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
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
    
    func loadCategories() {
        if let selectedLabel = selectedCategoryLabel {
            
            //Добавление заголовка категории
            view.addSubview(labelCategory)
            labelCategory.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([ //здесь ошибка, потому что в лейбл не передается значение трекера
                labelCategory.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 148),
                labelCategory.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
            ])
            
            categories = [TrackerCategory(label: selectedLabel, trackerMassiv: [])]
            newCategories = [Tracker(id: 1, name: selectedLabel, color: "", emodji: "", timetable: "")]
            
            //добавление списка трекеров
            collectionViewTrackers.delegate = self
            collectionViewTrackers.dataSource = self
            collectionViewTrackers.register(CombinedTrackerViewCell.self, forCellWithReuseIdentifier: "trackerCell")
            let cell = CombinedTrackerViewCell()
            collectionViewTrackers.addSubview(cell)
            view.addSubview(collectionViewTrackers)
            
            collectionViewTrackers.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionViewTrackers.topAnchor.constraint(equalTo: search.bottomAnchor, constant: 8),
                collectionViewTrackers.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                collectionViewTrackers.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                collectionViewTrackers.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        collectionViewTrackers.reloadData()
    }
    
    // MARK: - table settings
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
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
            
            if Int(labelCount.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ?? "0") != nil {
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
    
    @objc func buttonAction() {
        let createHabbit = NewHabitController()
        let createHabbitNavigationController = UINavigationController(rootViewController: createHabbit)
        present(createHabbitNavigationController, animated: true, completion: nil)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        print("Selected Date: \(selectedDate)")
        
        // Фильтрация массива данных по выбранной дате
        let filteredData = completedTrackers.filter { trackerRecord in
            return Calendar.current.isDate(trackerRecord.date, inSameDayAs: selectedDate)
        }
        print("Filtered Data: \(filteredData)")
    }
}
