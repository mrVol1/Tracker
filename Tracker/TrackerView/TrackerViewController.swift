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
    let container = UIDatePicker()
    let customFontBold = UIFont(name: "SFProDisplay-Bold", size: UIFont.labelFontSize)
    
    var selectedTrackerName: String?
    var selectedScheduleDays: [WeekDay] = []
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord]
    var newHabit: [Tracker]
    var createdCategoryName: String?
    var labelCategory: UILabel!
    
    var currentDate: Date = Date() {
        didSet {
            filterTrackersByDate(currentDate)
        }
    }
    
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
    
    private let collectionViewTrackers: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: "trackerCell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    init(categories: [TrackerCategory], completedTrackers: [TrackerRecord], newCategories: [Tracker]) {
        self.categories = categories
        self.completedTrackers = completedTrackers
        self.newHabit = newCategories
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.categories = []
        self.completedTrackers = []
        self.newHabit = []
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.delegate = self
        
        loadCategories()
        
        view.backgroundColor = .white
        
        collectionViewTrackers.delegate = self
        collectionViewTrackers.dataSource = self
        
        newHabitCreateController.habitCreateDelegate = self
        
        createButton()
        
        timeContainer()
        
        labelTracker()
        
        searchTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCategories()
    }
    
    
    // MARK: - Screen settings
    
    fileprivate func createButton() {
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
    }
    
    fileprivate func timeContainer() {
        //Создание контейнера для даты
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
    }
    
    fileprivate func labelTracker() {
        //создание лейбла "Трекеры"
        label.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)).withSize(34)
        label.textColor = .black
        label.text = "Трекеры"
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 48),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    fileprivate func searchTextField() {
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
    
    // MARK: - CollectionView setting
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newHabit.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as! TrackerViewCell
        
        let tracker = newHabit[indexPath.item]
        cell.configure(
            with: tracker,
            isChecked: false, //completedTrackers.contains(where: tracker),
            completedDaysCount: 0
        )

        cell.completion = { [weak self] in
            guard let self else { return }
            let trackerRecord = TrackerRecord(
                id: UUID(),
                date: self.currentDate,
                selectedDays: self.selectedScheduleDays,
                trackerId: tracker.id
            )
            self.completedTrackers.append(trackerRecord)
            self.collectionViewTrackers.reloadData()
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerViewCell else {
            return
        }
        cell.completion?()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
    }

    
    // MARK: - Screen Func
    
    @objc func searchValueChanged() {
        let searchText = search.text ?? ""
        applySearchFilter(searchText)
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
            view.addSubview(collectionViewTrackers)

            collectionViewTrackers.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionViewTrackers.topAnchor.constraint(equalTo: labelCategory.topAnchor, constant: 24),
                collectionViewTrackers.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                collectionViewTrackers.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                collectionViewTrackers.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 12)
            ])
            
            categories = [TrackerCategory(label: createdCategoryName!, trackerMassiv: [])]
            newHabit = [Tracker(id: 1, name: selectedTrackerName!, color: "", emodji: "", timetable: selectedScheduleDays)]
            
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
        if searchText.isEmpty {
            newHabit = categories.flatMap { $0.trackerMassiv ?? [] }
        } else {
            newHabit = categories.flatMap { category in
                category.trackerMassiv?.filter { tracker in
                    return tracker.name.lowercased().contains(searchText.lowercased())
                } ?? []
            }
        }
        collectionViewTrackers.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        true
    }
    
    @objc func buttonAction() {
        let createHabbit = ChoseHabitOrEventViewController()
        createHabbit.habitCreateDelegate = self
        let createHabbitNavigationController = UINavigationController(rootViewController: createHabbit)
        present(createHabbitNavigationController, animated: true, completion: nil)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        filterTrackersByDate(sender.date)
    }
    
    private func filterTrackersByDate(_ date: Date) {
        let dayOfWeek = Calendar.current.component(.weekday, from: date)
        let selectedWeekDay = WeekDay(rawValue: "\(dayOfWeek)")

        if let selectedWeekDay = selectedWeekDay {
            newHabit = newHabit.filter { tracker in
                let trackerWeekDays = tracker.timetable.compactMap { WeekDay(rawValue: $0.rawValue) }
                return trackerWeekDays.contains(selectedWeekDay)
            }
        } else {
            newHabit = []
        }
        collectionViewTrackers.reloadData()
    }
}

extension TrackerViewController: NewHabitCreateViewControllerDelegate {
    func didFinishCreatingHabitAndDismiss() {
        loadCategories()
    }
    
    
    func didCreateHabit(
        withCategoryLabel selectedCategoryString: String?,
        selectedScheduleDays: [WeekDay]?,
        trackerName selectedHabitString: String?
    ) {
        self.createdCategoryName = selectedCategoryString
        self.selectedTrackerName = selectedHabitString
        self.selectedScheduleDays = selectedScheduleDays ?? []
        
    }
}

extension TrackerViewController: ScheduleViewControllerDelegate {
    func didSelectScheduleDays(_ selectedDays: [WeekDay]) {
        self.selectedScheduleDays = selectedDays
    }
}
