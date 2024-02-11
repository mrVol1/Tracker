//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Eduard Karimov on 29/10/2023.
//

import UIKit

class TrackerViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let grayColor = UIColorsForProject()
    let search = UISearchTextField()
    let nameForLabelCategory = UILabel()
    let label = UILabel()
    let customFontBoldMidle = UIFont(name: "SFProDisplay-Medium", size: 19)
    let newHabitCreateController = NewHabitCreateViewController()
    
    var selectedTrackerName: String?
    var selectedScheduleDays: [WeekDay] = []
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord]
    var newCategories: [Tracker]
    var createdCategoryName: String?
    var labelCategory: UILabel!

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
    
    private let collectionViewTrackers: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "trackerCell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.delegate = self
        
        loadCategories()
        
        view.backgroundColor = .white
        
        collectionViewTrackers.delegate = self
        collectionViewTrackers.dataSource = self
        
        newHabitCreateController.habitCreateDelegate = self
        
        //Создание кнопки "+"
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
        
        search.addTarget(self, action: #selector(searchValueChanged), for: .editingChanged)
    }
    
    @objc func searchValueChanged() {
        let searchText = search.text ?? ""
        applySearchFilter(searchText)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as! TrackerCollectionViewCell
        
        let tracker = newCategories[indexPath.item]
        cell.configure(with: tracker)
        
        return cell
    }
    
    func loadCategories() {
        if createdCategoryName != nil {
            
            //настройка лейбла категории
            
            labelCategory = UILabel()
            labelCategory.textColor = .black
            labelCategory.text = createdCategoryName
            labelCategory.font = UIFontMetrics.default.scaledFont(for: customFontBoldMidle ?? UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.bold) ).withSize(19)
            view.addSubview(labelCategory)
            
            labelCategory.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                labelCategory.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 148),
                labelCategory.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
            ])
            
            //добавление списка трекеров
            collectionViewTrackers.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "trackerCell")
            view.addSubview(collectionViewTrackers)
            
            collectionViewTrackers.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionViewTrackers.topAnchor.constraint(equalTo: labelCategory.topAnchor, constant: 24),
                collectionViewTrackers.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                collectionViewTrackers.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                collectionViewTrackers.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            categories = [TrackerCategory(label: createdCategoryName!, trackerMassiv: [])]
            newCategories = [Tracker(id: 1, name: selectedTrackerName ?? createdCategoryName!, color: "", emodji: "", timetable: "")]
            
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
            
            //добавление надписи под картинкой
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
    
    func applySearchFilter(_ searchText: String) {
        guard !categories.isEmpty else {
            newCategories = []
            collectionViewTrackers.reloadData()
            return
        }

        if searchText.isEmpty {
            newCategories = categories.flatMap { $0.trackerMassiv ?? [] }
        } else {
            newCategories = categories.flatMap { category -> [Tracker] in
                let filteredTrackers = (category.trackerMassiv ?? []).filter { tracker in
                    return tracker.name.lowercased().contains(searchText.lowercased())
                }
                return filteredTrackers
            }
        }

        collectionViewTrackers.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - table settings
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func buttonAction() {
        let createHabbit = ChoseHabitOrEventViewController()
        let createHabbitNavigationController = UINavigationController(rootViewController: createHabbit)
        present(createHabbitNavigationController, animated: true, completion: nil)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let filteredTrackers = completedTrackers.filter { trackerRecord in
            return Calendar.current.isDate(trackerRecord.date, inSameDayAs: selectedDate)
        }
        newCategories = filteredTrackers.compactMap { trackerRecord in
            guard let index = newCategories.firstIndex(where: { $0.id == trackerRecord.trackerId }) else {
                return nil
            }
            return newCategories[index]
        }
        collectionViewTrackers.reloadData()
    }
}

extension TrackerViewController: NewHabitCreateViewControllerDelegate {
    func didCreateHabit(withCategoryLabel selectedCategoryString: String?, selectedScheduleDays: [WeekDay]?, categories: String?) {
        
    }
    
    
    func didCreateHabit(
        withCategoryLabel selectedCategoryLabel: String?,
        selectedTrackerName: String?,
        selectedScheduleDays: [WeekDay]?
    ) {
        // Обновление данных в TrackerViewController
        self.createdCategoryName = selectedCategoryLabel
        self.selectedTrackerName = selectedTrackerName
        self.selectedScheduleDays = selectedScheduleDays ?? []
        
        // Обновление интерфейса
        labelCategory.text = selectedCategoryLabel
    }
}
