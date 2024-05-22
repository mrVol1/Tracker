//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Eduard Karimov on 29/10/2023.
//

import UIKit
import CoreData

class TrackerViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
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
    var trackers: [Tracker] = []
    var completedTrackers: Set<UUID> = []
    var newHabit: [Tracker]
    var completedDaysCount: Int = 0
    var selectedTrackers: [UUID: Bool] = [:]
    var previousHeaderView: CategoryNameClass?
    var didCreateHabitCalled = false
    var isDatePickerSelected = false
    var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    
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
    
    let collectionViewTrackers: UICollectionView = {
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
        view.backgroundColor = .white
        
        collectionViewTrackers.delegate = self
        collectionViewTrackers.dataSource = self
        
        setupFetchedResultsController()
        fetchData()
        
        setupUI()
        
        createButton()
        timeContainer()
        labelTracker()
        searchTextField()
        
        loadCategories()
    }
    
    private func fetchData() {
        guard let fetchedResultsController = fetchedResultsController else {
            print("fetchedResultsController is nil")
            return
        }
        
        do {
            try fetchedResultsController.performFetch()
            print("Fetch successful, number of sections: \(fetchedResultsController.sections?.count ?? 0)")
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }

    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "label", ascending: true)]

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            print("Fetched results controller setup successful")
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }
    
    // MARK: - Screen settings
    
    private func setupUI() {
        view.addSubview(collectionViewTrackers)
        collectionViewTrackers.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionViewTrackers.topAnchor.constraint(equalTo: view.topAnchor),
            collectionViewTrackers.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewTrackers.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionViewTrackers.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
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
        let numberOfSections = fetchedResultsController.sections?.count ?? 0
        print("Number of sections: \(numberOfSections)")
        return numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        let numberOfItems = sections[section].numberOfObjects
        print("Number of items in section \(section): \(numberOfItems)")
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerViewCell else {
            fatalError("Failed to dequeue TrackerViewCell")
        }

        let trackerCategory = fetchedResultsController.object(at: indexPath)

        if let trackersData = trackerCategory.trackerArray {
            do {
                let decoder = JSONDecoder()
                let trackers = try decoder.decode([Tracker].self, from: trackersData as! Data)
                
                if indexPath.item < trackers.count {
                    let tracker = trackers[indexPath.item]
                    
                    let isChecked = completedTrackers.contains(tracker.id)
                    let completedDaysCount = isChecked ? 1 : 0
                    
                    cell.configure(with: tracker, isChecked: isChecked, completedDaysCount: completedDaysCount)
                    
                    cell.completion = { [weak self] in
                        guard let self = self else { return }
                        
                        if isChecked {
                            self.completedTrackers.remove(tracker.id)
                        } else {
                            self.completedTrackers.insert(tracker.id)
                        }
                        
                        cell.configure(with: tracker, isChecked: !isChecked, completedDaysCount: !isChecked ? 1 : 0)
                    }
                }
            } catch {
                print("Failed to decode trackers: \(error)")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoryNameClass.reuseIdentifier, for: indexPath) as! CategoryNameClass
            let trackerCategory = fetchedResultsController.sections?[indexPath.section]
            headerView.titleLabel.text = trackerCategory?.name
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
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Controller will change content")
        collectionViewTrackers.performBatchUpdates(nil, completion: nil)
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Controller did change content")
//        collectionViewTrackers.reloadData()
        loadCategories()
    }
    
    // MARK: - Screen Func
    
    @objc func searchValueChanged() {
        let searchText = search.text ?? ""
        applySearchFilter(searchText)
    }
    
    func loadCategories() {
        guard let sections = fetchedResultsController.sections else {
            print("No sections found")
            return
        }
        
        categories = sections.reduce(into: [TrackerCategory]()) { result, section in
            if let coreDataCategories = section.objects as? [TrackerCategoryCoreData] {
                let newCategories = coreDataCategories.map { coreDataCategory in
                    let trackers = (try? JSONDecoder().decode([Tracker].self, from: (coreDataCategory.trackerArray ?? Data() as NSObject) as! Data)) ?? []
                    return TrackerCategory(label: coreDataCategory.label ?? "", trackerArray: trackers)
                }
                result.append(contentsOf: newCategories)
            }
        }
        
        print("Загрузка категорий: \(categories.count)")
        DispatchQueue.main.async {
            self.collectionViewTrackers.reloadData()
        }
    }
    
    func updateUI() {
        print("Обновление интерфейса")
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
    
    func filterTrackersByDate(_ date: Date) {
        let dayOfWeek = Calendar.current.component(.weekday, from: date)
        let selectedWeekDay = weekDayFromNumber(dayOfWeek)

        print("Фильтрация трекеров по дате: \(date), день недели: \(String(describing: selectedWeekDay))")

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
                print("Трекеры не найдены для выбранной даты")
            } else {
                collectionViewTrackers.isHidden = false
                categories = filteredCategories
                DispatchQueue.main.async {
                    self.collectionViewTrackers.reloadData()
                }
                print("Найдено трекеров для выбранной даты: \(filteredCategories.count)")
            }
        }
    }
}
