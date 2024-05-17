//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Eduard Karimov on 29/10/2023.
//

import UIKit

class TrackerViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let customFontBold = UIFont(name: "SFProDisplay-Bold", size: UIFont.labelFontSize)
    let customFontBoldMidle = UIFont(name: "SFProDisplay-Medium", size: 19)
    let search = UISearchTextField()
    let defaultLabel = UILabel()
    let newHabitCreateController = NewHabitCreateViewController()
    let newEventCreateController = NewEventCreateViewController()
    let datePicker = UIDatePicker()
    
    var selectedEventString: String?
    var selectedHabitString: String?
    var createdCategoryName: String?
    var selectedColor: String?
    var selectedEmodji: String?
    var selectedScheduleDays: [WeekDay] = []
    var categories: [TrackerCategory] = []
    var completedTrackers: Set<UUID> = []
    var newHabit: [Tracker]
    var completedDaysCount: Int = 0
    var selectedTrackers: [UUID: Bool] = [:]
    var previousHeaderView: CategoryNameClass?
    var didCreateHabitCalled = false
    var isDatePickerSelected = false
    
    var currentDate: Date = Date() {
        didSet {
            filterTrackersByDate(currentDate)
        }
    }
    
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
        collectionView.register(CategoryNameClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryNameClass.reuseIdentifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    init(categories: [TrackerCategory], completedTrackers: [TrackerRecord], newCategories: [Tracker], color: String, emodji: String) {
        self.categories = categories
        self.newHabit = newCategories
        self.selectedColor = color
        self.selectedEmodji = emodji
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.categories = []
        self.completedTrackers = []
        self.newHabit = []
        self.selectedColor = ""
        self.selectedEmodji = ""
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
        
        newEventCreateController.eventCreateDelegate = self
        
        createButton()
        
        timeContainer()
        
        labelTracker()
        
        searchTextField()
        
        layoutSetup()
        
        if isDatePickerSelected {
            filterTrackersByDate(datePicker.date)
        }
    }
    
    // MARK: - Screen settings
    
    fileprivate func layoutSetup() {
        if let layout = collectionViewTrackers.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.headerReferenceSize = CGSize(width: collectionViewTrackers.frame.width, height: 50)
        }
    }
    
    fileprivate func createButton() {
        plusButton.addTarget(self, action: #selector(buttonActionForHabit), for: .touchUpInside)
        plusButton.setImage(UIImage(named: "Add tracker"), for: .normal)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.setTitleColor(.black, for: .normal)
        view.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6)
        ])
    }
    
    fileprivate func timeContainer() {
        datePicker.datePickerMode = .date
        datePicker.minimumDate = nil
        view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 222)
        ])
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    fileprivate func labelTracker() {
        defaultLabel.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)).withSize(34)
        defaultLabel.textColor = .black
        defaultLabel.text = "Трекеры"
        view.addSubview(defaultLabel)
        
        defaultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            defaultLabel.bottomAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 48),
            defaultLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    fileprivate func searchTextField() {
        search.placeholder = "Поиск"
        view.addSubview(search)
        
        search.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            search.heightAnchor.constraint(equalToConstant: 36),
            search.topAnchor.constraint(equalTo: defaultLabel.safeAreaLayoutGuide.topAnchor, constant: 48),
            search.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            search.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        search.addTarget(self, action: #selector(searchValueChanged), for: .editingChanged)
    }
    
    // MARK: - CollectionView setting
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = categories[section]
        return category.trackerArray?.count ?? 0
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as! TrackerViewCell

        let category = categories[indexPath.section]
        if let tracker = category.trackerArray?[indexPath.item] {
            let isChecked = completedTrackers.contains { $0 == tracker.id }

            cell.configure(
                with: tracker,
                isChecked: isChecked,
                completedDaysCount: isChecked ? 1 : 0
            )

            cell.completion = { [weak self] in
                guard let self = self else { return }

                if isChecked {
                    self.completedTrackers.remove(tracker.id)
                } else {
                    self.completedTrackers.insert(tracker.id)
                }

                cell.configure(
                    with: tracker,
                    isChecked: !isChecked,
                    completedDaysCount: !isChecked ? 1 : 0
                )
            }
        }

        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoryNameClass.reuseIdentifier, for: indexPath) as! CategoryNameClass
            headerView.titleLabel.text = categories[indexPath.section].label
            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerViewCell else {
            return
        }
        cell.completion?()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 3, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
    
    
    // MARK: - Screen Func
    
    @objc func searchValueChanged() {
        let searchText = search.text ?? ""
        applySearchFilter(searchText)
    }
    
    func loadCategories() {
        
        if categories.isEmpty {
            guard let defaultImage = UIImage(named: "Stars") else { return }
            let imageView = UIImageView(image: defaultImage)
            view.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
            let defultLabel = UILabel()
            defultLabel.textColor = .black
            defultLabel.text = "Что будем отслеживать?"
            view.addSubview(defultLabel)
            
            defultLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                defultLabel.bottomAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.bottomAnchor, constant: 28),
                defultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        } else if selectedHabitString != nil || selectedEventString != nil {
            updateUI()
        }
    }
    
    func updateUI() {
        view.addSubview(collectionViewTrackers)
        
        collectionViewTrackers.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionViewTrackers.topAnchor.constraint(equalTo: search.topAnchor, constant: 54),
            collectionViewTrackers.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionViewTrackers.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionViewTrackers.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 12)
        ])
        
        if let layout = collectionViewTrackers.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 167, height: 148)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.headerReferenceSize = CGSize(width: collectionViewTrackers.frame.width, height: 50)
        }
    }
    
    func applySearchFilter(_ searchText: String) {
        if searchText.isEmpty {
            newHabit = categories.flatMap { $0.trackerArray ?? [] }
        } else {
            newHabit = categories.flatMap { category in
                category.trackerArray?.filter { tracker in
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let searchText = textField.text, searchText.isEmpty {
        }
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        true
    }
    
    @objc func buttonActionForHabit() {
        let createTracker = ChoseHabitOrEventViewController()
        createTracker.habitCreateDelegate = self
        createTracker.eventCreateDelegate = self
        let createHabbitNavigationController = UINavigationController(rootViewController: createTracker)
        present(createHabbitNavigationController, animated: true, completion: nil)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        isDatePickerSelected = true
        filterTrackersByDate(sender.date)
    }
    
    private func weekDayFromNumber(_ number: Int) -> WeekDay? {
        switch number {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return nil
        }
    }
    
    private func filterTrackersByDate(_ date: Date) {
        let dayOfWeek = Calendar.current.component(.weekday, from: date)
        let selectedWeekDay = weekDayFromNumber(dayOfWeek)

        if let selectedWeekDay = selectedWeekDay {
            var filteredCategories = [TrackerCategory]()
            for category in categories {
                if let filteredTrackers = category.trackerArray?.filter({ $0.timetable.contains(selectedWeekDay) }), !filteredTrackers.isEmpty {
                    let filteredCategory = TrackerCategory(label: category.label, trackerArray: filteredTrackers)
                    filteredCategories.append(filteredCategory)
                }
            }

            if filteredCategories.isEmpty {
                collectionViewTrackers.isHidden = true
            } else {
                collectionViewTrackers.isHidden = false
                categories = filteredCategories
                collectionViewTrackers.reloadData()
            }
        }
    }
}

extension TrackerViewController: NewHabitCreateViewControllerDelegate {
    func didFinishCreatingHabitAndDismiss() {
      loadCategories()
    }
    
    func didCreateHabit(with trackerCategoryInMain: TrackerCategory) {
        selectedHabitString = trackerCategoryInMain.trackerArray?.first?.name
        selectedScheduleDays = trackerCategoryInMain.trackerArray?.first?.timetable ?? []
        createdCategoryName = trackerCategoryInMain.label
        selectedColor = trackerCategoryInMain.trackerArray?.first?.color
        selectedEmodji = trackerCategoryInMain.trackerArray?.first?.emodji

        if let existingCategoryIndex = categories.firstIndex(where: { $0.label == createdCategoryName }) {
            let existingCategory = categories[existingCategoryIndex]
            let newHabit = Tracker(id: UUID(), name: selectedHabitString ?? "", color: selectedColor ?? "", emodji: selectedEmodji ?? "", timetable: selectedScheduleDays)
            var updatedTrackerArray = existingCategory.trackerArray ?? []
            updatedTrackerArray.append(newHabit)
            let updatedCategory = TrackerCategory(label: existingCategory.label, trackerArray: updatedTrackerArray)
            categories[existingCategoryIndex] = updatedCategory
        } else {
            let newHabit = Tracker(id: UUID(), name: selectedHabitString ?? "", color: selectedColor ?? "", emodji: selectedEmodji ?? "", timetable: selectedScheduleDays)
            let newCategory = TrackerCategory(label: createdCategoryName ?? "", trackerArray: [newHabit])
            categories.append(newCategory)
        }
        collectionViewTrackers.reloadData()
    }
}

extension TrackerViewController: ScheduleViewControllerDelegate {
    func didSelectScheduleDays(_ selectedDays: [WeekDay]) {
        self.selectedScheduleDays = selectedDays
    }
}

extension TrackerViewController: NewEventCreateViewControllerDelegate {
    
    func didCreateEvent(with trackerCategoryInMain: TrackerCategory) {
        selectedEventString = trackerCategoryInMain.trackerArray?.first?.name
        createdCategoryName = trackerCategoryInMain.label
        selectedColor = trackerCategoryInMain.trackerArray?.first?.color
        selectedEmodji = trackerCategoryInMain.trackerArray?.first?.emodji

        if let existingCategoryIndex = categories.firstIndex(where: { $0.label == createdCategoryName }) {
            let existingCategory = categories[existingCategoryIndex]
            let newHabit = Tracker(id: UUID(), name: selectedEventString ?? "", color: selectedColor ?? "", emodji: selectedEmodji ?? "", timetable: [])
            var updatedTrackerArray = existingCategory.trackerArray ?? []
            updatedTrackerArray.append(newHabit)
            let updatedCategory = TrackerCategory(label: existingCategory.label, trackerArray: updatedTrackerArray)
            categories[existingCategoryIndex] = updatedCategory
        } else {
            let newHabit = Tracker(id: UUID(), name: selectedEventString ?? "", color: selectedColor ?? "", emodji: selectedEmodji ?? "", timetable: [])
            let newCategory = TrackerCategory(label: createdCategoryName ?? "", trackerArray: [newHabit])
            categories.append(newCategory)
        }
        collectionViewTrackers.reloadData()
    }
    
    func didFinishCreatingEventAndDismiss() {
        loadCategories()
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
