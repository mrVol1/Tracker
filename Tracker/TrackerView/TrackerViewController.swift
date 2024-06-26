//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Eduard Karimov on 29/10/2023.
//

import UIKit
import CoreData

class TrackerViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, NewHabitCreateViewControllerDelegate {
    
    let customFontBold = UIFont(name: "SFProDisplay-Bold", size: UIFont.labelFontSize)
    let customFontBoldMidle = UIFont(name: "SFProDisplay-Medium", size: 19)
    let search = UISearchTextField()
    let defaultLabel = UILabel()
    let datePicker = UIDatePicker()
    
    var selectedEventString: String?
    var selectedHabitString: String?
    var createdCategoryName: String?
    var selectedColor: String?
    var selectedEmoji: String?
    var selectedScheduleDays: [WeekDay] = []
    var categories: [TrackerCategory] = []
    var trackers: [Tracker] = []
    var completedTrackers: Set<UUID> = []
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
        button.widthAnchor.constraint(equalToConstant: 42).isActive = true
        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
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
    
    init(categories: [TrackerCategory] = [], completedTrackers: [UUID] = [], selectedColor: String = "", selectedEmoji: String = "") {
        self.categories = categories
        self.completedTrackers = Set(completedTrackers)
        self.selectedColor = selectedColor
        self.selectedEmoji = selectedEmoji
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
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
        view.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6)
        ])
    }
    
    fileprivate func timeContainer() {
        datePicker.datePickerMode = .date
        view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 222)
        ])
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    fileprivate func labelTracker() {
        defaultLabel.font = customFontBold?.withSize(34) ?? UIFont.systemFont(ofSize: 34, weight: .bold)
        defaultLabel.textColor = .black
        defaultLabel.text = "Трекеры"
        view.addSubview(defaultLabel)
        
        defaultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            defaultLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 16),
            defaultLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    fileprivate func searchTextField() {
        search.placeholder = "Поиск"
        view.addSubview(search)
        
        search.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            search.heightAnchor.constraint(equalToConstant: 36),
            search.topAnchor.constraint(equalTo: defaultLabel.bottomAnchor, constant: 16),
            search.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            search.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        search.addTarget(self, action: #selector(searchValueChanged), for: .editingChanged)
    }
    
    // MARK: - CollectionView setting
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerViewCell else {
            fatalError("Failed to dequeue TrackerViewCell")
        }
        
        let trackerCategory = fetchedResultsController.object(at: indexPath)
        
        if let trackersSet = trackerCategory.tracker, let trackers = trackersSet.allObjects as? [Tracker] {
            if indexPath.item < trackers.count {
                let tracker = trackers[indexPath.item]
                
                cell.configure(with: tracker, isChecked: false, completedDaysCount: 0)
            }
        }
        
        return cell
    }


    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoryNameClass.reuseIdentifier, for: indexPath) as? CategoryNameClass else {
            fatalError("Failed to dequeue CategoryNameClass")
        }
        
        let category = fetchedResultsController.object(at: indexPath)
        headerView.titleLabel.text = category.label
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        
        // Высота ячейки счетчика и кнопки
        let cellHeight: CGFloat = 148
        
        // Дополнительные вертикальные расстояния
        let titleToCellSpacing: CGFloat = 12
                
        // Расчет расстояния между двумя ячейками в ряду
        let cellSpacing: CGFloat = 9
        
        // Ширина ячейки с учетом расстояний
        let cellWidth = (screenWidth - 3 * cellSpacing) / 2
        
        // Если ячейка первая в ряду, то добавляем дополнительное вертикальное расстояние сверху
        let additionalVerticalSpacing = indexPath.item % 2 == 0 ? titleToCellSpacing : 0
        
        return CGSize(width: cellWidth, height: cellHeight + additionalVerticalSpacing)
    }
    
    // MARK: - Data handling
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionViewTrackers.performBatchUpdates(nil, completion: nil)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionViewTrackers.performBatchUpdates(nil, completion: nil)
    }
    
    // MARK: - Actions
    
    @objc private func buttonActionForHabit() {
        let newHabitVC = NewHabitCreateViewController()
        newHabitVC.habitCreateDelegate = self
        let navController = UINavigationController(rootViewController: newHabitVC)
        present(navController, animated: true, completion: nil)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
    }
    
    @objc private func searchValueChanged(_ sender: UISearchTextField) {
        if let searchText = sender.text, !searchText.isEmpty {
            filterTrackersBySearchText(searchText)
        } else {
            fetchData()
        }
    }
    
    private func filterTrackersByDate(_ date: Date) {
        guard let fetchedResultsController = fetchedResultsController else {
            print("fetchedResultsController is nil")
            return
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1)
        
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "ANY trackers.creationDate >= %@ AND ANY trackers.creationDate <= %@", startOfDay as CVarArg, endOfDay! as CVarArg)
        
        do {
            try fetchedResultsController.performFetch()
            collectionViewTrackers.reloadData()
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }
    
    private func filterTrackersBySearchText(_ searchText: String) {
        guard let fetchedResultsController = fetchedResultsController else {
            print("fetchedResultsController is nil")
            return
        }
        
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "label CONTAINS[cd] %@", searchText)
        
        do {
            try fetchedResultsController.performFetch()
            collectionViewTrackers.reloadData()
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }
    
    private func loadCategories() {
        guard let fetchedResultsController = fetchedResultsController else {
            print("fetchedResultsController is nil")
            return
        }
        
        do {
            try fetchedResultsController.performFetch()
            collectionViewTrackers.reloadData()
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }
    
    // MARK: - HabitCreationViewControllerDelegate
    func didCreateHabit(with category: TrackerCategoryCoreData) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            print("Failed to get context")
            return
        }
        
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = trackerCoreData.id
        trackerCoreData.name = trackerCoreData.name
        trackerCoreData.timetable = trackerCoreData.timetable
        trackerCoreData.color = trackerCoreData.color
        trackerCoreData.emoji = trackerCoreData.emoji
        
        if let categoryLabel = trackerCoreData.category?.label {
            let categoryFetch: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
            categoryFetch.predicate = NSPredicate(format: "label == %@", categoryLabel)
            
            do {
                let categories = try context.fetch(categoryFetch)
                if let category = categories.first {
                    trackerCoreData.category = category
                    category.addToTrackers(trackerCoreData)
                } else {
                    let newCategory = TrackerCategoryCoreData(context: context)
                    newCategory.label = categoryLabel
                    newCategory.addToTrackers(trackerCoreData)
                    trackerCoreData.category = newCategory
                }
            } catch {
                print("Failed to fetch categories: \(error)")
            }
        }
        
        do {
            try context.save()
            fetchData()
            collectionViewTrackers.reloadData()
        } catch {
            print("Failed to save new tracker: \(error)")
        }
    }
    
    func didFinishCreatingHabitAndDismiss() {
        
    }
}
