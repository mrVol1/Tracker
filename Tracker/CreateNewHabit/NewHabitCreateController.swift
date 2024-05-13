//
//  NewHabitCreateController.swift
//  Tracker
//
//  Created by Eduard Karimov on 26/11/2023.
//

import UIKit
import CoreData

enum TableSection: Int, CaseIterable {
    case categories
    case schedule
}

enum CollectionType {
    case emoji
    case color
}


protocol NewHabitCreateViewControllerDelegate: AnyObject {
    func didCreateHabit(with trackerCategoryInMain: TrackerCategory)
    func didFinishCreatingHabitAndDismiss()
}

final class NewHabitCreateViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, AddCategoryViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var selectedCategoryString: String?
    var selectedScheduleDays: [WeekDay] = []
    var selectedTrackerName: String?
    var cellWithCategoryLabel: CategoryTableViewCellForHabit?
    var selectedIndexEmoji: Set<IndexPath> = []
    var selectedIndexColor: Set<IndexPath> = []
    var selectedEmoji: String?
    var selectedColor: String?
    var isSelectedEmodji: Bool?
    var isSelectedColor: Bool?
    var colorSelectedEmodji: UIColor?
    var emoji: String?
    
    weak var scheduleDelegate: ScheduleViewControllerDelegate?
    weak var habitCreateDelegate: NewHabitCreateViewControllerDelegate?
    weak var addCategoryDelegate: AddCategoryViewControllerDelegate?
    
    let label = UILabel()
    let trackerName = UITextField()
    let saveButton = UIButton()
    let cancelButton = UIButton()
    let tableView = UITableView()
    let labelEmoji = UILabel()
    let labelColors = UILabel()
    let customFontBold = UIFont(name: "SFProDisplay-Medium", size: UIFont.labelFontSize)
    let entityTrackerName = "TrackerCoreData"
    
    private var trackerRecord: TrackerRecord?
    private let emojis: [String] = ["🙂", "😺", "🌺", "🐶", "♥️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🌴", "😪"]
    
    private let tableColors: [UIColor] = [
        HabitColors.redColor,
        HabitColors.orangeColor,
        HabitColors.blueColor,
        HabitColors.purpleColor,
        HabitColors.lightGreenColor,
        HabitColors.lilacColor,
        HabitColors.palePinkColor,
        HabitColors.lightBlueColor,
        HabitColors.emeraldColor,
        HabitColors.darkBlueColor,
        HabitColors.lightRedColor,
        HabitColors.paleLilacColor,
        HabitColors.goldColor,
        HabitColors.skyBlueColor,
        HabitColors.darkLilacColor,
        HabitColors.lightPurpleColor,
        HabitColors.palePurpleColor,
        HabitColors.greenColor
    ]
    
    fileprivate func configereKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.scrollContentView.addGestureRecognizer(tapGesture)
        saveButton.addTarget(self, action: #selector(buttonActionForHabitSave), for: .touchUpInside)
    }
    
    private let emojiCollectionView: UICollectionView = {
        let layoutEmodji = UICollectionViewFlowLayout()
        layoutEmodji.scrollDirection = .horizontal
        let collectionViewEmodji = UICollectionView(frame: .zero, collectionViewLayout: layoutEmodji)
        collectionViewEmodji.translatesAutoresizingMaskIntoConstraints = false
        collectionViewEmodji.backgroundColor = .clear
        collectionViewEmodji.register(EmodjiCollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCell")
        return collectionViewEmodji
    }()
    
    private let colorsCollectionView: UICollectionView = {
        let layoutColors = UICollectionViewFlowLayout()
        layoutColors.scrollDirection = .horizontal
        let collectionViewColors = UICollectionView(frame: .zero, collectionViewLayout: layoutColors)
        collectionViewColors.translatesAutoresizingMaskIntoConstraints = false
        collectionViewColors.backgroundColor = .clear
        collectionViewColors.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "ColorsCell")
        return collectionViewColors
    }()
    
    private lazy var buttonsContainer: UIStackView = {
        saveButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        saveButton.setTitle("Создать", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 16
        saveButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
        saveButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        saveButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        cancelButton.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        cancelButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.layer.cornerRadius = 16
        cancelButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        cancelButton.addTarget(self, action: #selector(buttonActionForHabitCancel), for: .touchUpInside)
        
        let buttonsContainer = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        buttonsContainer.axis = .horizontal
        buttonsContainer.spacing = 16
        buttonsContainer.distribution = .fillEqually
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        return buttonsContainer
    }()
    
    private lazy var scrollContentView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerName.delegate = self
        
        view.backgroundColor = .white
        
        configureLabel()
        configureTrackerName()
        configureTableView()
        configerEmodjiLabel()
        configerColorsLabel()
        
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        
        updateCreateButtonState()
        
        configereKeyboard()
        
        configerScrollView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCreateButtonState()
    }
    
    // MARK: - Screen Config
    
    fileprivate func configerScrollView() {
        view.addSubview(scrollContentView)
        
        scrollContentView.addSubview(label)
        scrollContentView.addSubview(trackerName)
        scrollContentView.addSubview(tableView)
        scrollContentView.addSubview(labelEmoji)
        scrollContentView.addSubview(emojiCollectionView)
        scrollContentView.addSubview(labelColors)
        scrollContentView.addSubview(colorsCollectionView)
        scrollContentView.addSubview(buttonsContainer)
        
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            label.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            
            trackerName.widthAnchor.constraint(equalToConstant: 343),
            trackerName.heightAnchor.constraint(equalToConstant: 75),
            trackerName.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            trackerName.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 38),
            
            tableView.widthAnchor.constraint(equalToConstant: 343),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            tableView.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: trackerName.bottomAnchor, constant: 24),
            
            labelEmoji.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            labelEmoji.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 28),
            labelEmoji.heightAnchor.constraint(equalToConstant: 18),
            
            emojiCollectionView.topAnchor.constraint(equalTo: labelEmoji.bottomAnchor, constant: 24),
            emojiCollectionView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),
            emojiCollectionView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: 360),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 180),
            
            labelColors.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 44),
            labelColors.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 28),
            
            colorsCollectionView.topAnchor.constraint(equalTo: labelColors.bottomAnchor, constant: 24),
            colorsCollectionView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),
            colorsCollectionView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: 360),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: 180),
            
            buttonsContainer.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 24),
            buttonsContainer.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 60),
            buttonsContainer.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func configureLabel() {
        label.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)).withSize(16)
        label.textColor = .black
        label.text = "Создание привычки"
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureTrackerName() {
        trackerName.delegate = self
        
        trackerName.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        trackerName.placeholder = "Введите название трекера"
        trackerName.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        trackerName.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
        trackerName.layer.cornerRadius = 16
        trackerName.clipsToBounds = true
        trackerName.translatesAutoresizingMaskIntoConstraints = false
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: trackerName.frame.height))
        trackerName.leftView = leftPaddingView
        trackerName.leftViewMode = .always
        
    }
    
    private func configureTableView() {
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.sectionHeaderHeight = 0
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        setupTableHeader()
        tableView.register(CategoryTableViewCellForHabit.self, forCellReuseIdentifier: "categoryCell")
        tableView.register(CategoryTableViewCellForHabit.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configerEmodjiLabel() {
        labelEmoji.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.semibold)).withSize(19)
        labelEmoji.textColor = .black
        labelEmoji.text = "Emodji"
        
        labelEmoji.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configerColorsLabel() {
        labelColors.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.semibold)).withSize(19)
        labelColors.textColor = .black
        labelColors.text = "Цвет"
        
        labelColors.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    // MARK: - UITableView Data Source and Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableSection(rawValue: indexPath.section) {
        case .categories:
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCellForHabit
            cell.titleLabel.text = "Категории"
            cell.titleLabel.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1.0)
            cell.titleLabel.textAlignment = .center
            cell.accessoryType = .disclosureIndicator
            
            if let selectedCategoryString = selectedCategoryString {
                cell.categoryLabel.text = selectedCategoryString
                cell.categoryLabel.isHidden = false
            } else {
                cell.categoryLabel.text = ""
                cell.categoryLabel.isHidden = true
            }
            
            cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
            cellWithCategoryLabel = cell
            return cell
            
        case .schedule:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryTableViewCellForHabit
            cell.titleLabel.text = "Расписание"
            cell.titleLabel.textColor = .black
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
            
            if !selectedScheduleDays.isEmpty {
                let scheduleText = selectedScheduleDays.map { $0.rawValue.prefix(3) }.joined(separator: ", ")
                cell.daysLabel.text = scheduleText
            } else {
                cell.daysLabel.text = nil
            }
            
            return cell
            
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch TableSection(rawValue: indexPath.section) {
        case .categories:
            firstWayForButtonActionForCreateCategory()
        case .schedule:
            buttonActionForCreateSchedule()
        case .none:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let separatorWidth: CGFloat = 311
        let separatorHeight: CGFloat = 1
        let separator = UIView(frame: CGRect(x: (cell.frame.width - separatorWidth) / 2, y: cell.frame.height - separatorHeight, width: separatorWidth, height: separatorHeight))
        separator.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        cell.contentView.addSubview(separator)
    }
    
    
    // MARK: - collectionViewSettings
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emojis.count
        } else if collectionView == colorsCollectionView {
            return tableColors.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmodjiCollectionViewCell
            
            let emoji = emojis[indexPath.item]
            let isSelectedEmodji = selectedIndexEmoji.contains(indexPath)
            let colorSelectedEmodji = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 1.0)
            
            cell.configure(withEmoji: emoji, colorEmodji: colorSelectedEmodji, colorCornerRadius: 16, isSelectedEmodji: isSelectedEmodji)
            
            return cell
        } else if collectionView == colorsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCell", for: indexPath) as! ColorCollectionViewCell
            
            let color = tableColors[indexPath.item]
            let isSelectedColor = selectedIndexColor.contains(indexPath)
            cell.configure(withColor: color, isSelectedColor: isSelectedColor)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            selectedEmoji = emojis[indexPath.item]
            let isSelectedEmodji = selectedIndexEmoji.contains(indexPath)
            
            if isSelectedEmodji {
                selectedIndexEmoji.remove(indexPath)
            } else {
                if let currentSelectedIndexPath = selectedIndexEmoji.first {
                    selectedIndexEmoji.remove(currentSelectedIndexPath)
                }
                
                selectedIndexEmoji.insert(indexPath)
            }
            collectionView.reloadData()
            updateCreateButtonState()
        } else if collectionView == colorsCollectionView {
            let color = tableColors[indexPath.item]
            selectedColor = color.description
            let isSelectedColor = selectedIndexColor.contains(indexPath)
            
            if isSelectedColor {
                selectedIndexColor.remove(indexPath)
            } else {
                if let currentSelectedIndexPath = selectedIndexColor.first {
                    selectedIndexColor.remove(currentSelectedIndexPath)
                }
                selectedIndexColor.insert(indexPath)
            }
            collectionView.reloadData()
            updateCreateButtonState()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    // MARK: - Screen Func
    
    @objc private func buttonActionForHabitSave() {
        guard let selectedTrackerName = trackerName.text,
              !selectedTrackerName.isEmpty,
              let selectedCategoryString = selectedCategoryString,
              let selectedEmoji = selectedEmoji,
              let selectedColor = selectedColor,
              !selectedScheduleDays.isEmpty else {
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let trackerEntity = NSEntityDescription.entity(forEntityName: entityTrackerName, in: managedContext) else {
            fatalError("Entity description for \(entityTrackerName) not found")
        }

        let tracker = NSManagedObject(entity: trackerEntity, insertInto: managedContext)
        
        tracker.setValue(selectedTrackerName, forKey: "name")
        tracker.setValue(selectedColor, forKey: "color")
        tracker.setValue(selectedEmoji, forKey: "emodji")
        tracker.setValue(UUID(), forKey: "id")
        
        let transformer = TransformerValue()
        
        if let transformedDays = transformer.transformedValue(selectedScheduleDays) as? NSData {
            tracker.setValue(transformedDays, forKey: "timetable")
        }
        
        do {
            try managedContext.save()
            print("Tracker saved successfully.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
//        let tracker = Tracker(id: UUID(), name: selectedTrackerName, color: selectedColor, emodji: selectedEmoji, timetable: selectedScheduleDays)
        
       // let trackerCategoryInMain = TrackerCategory(label: selectedCategoryString, trackerArray: [tracker])
        
        if let delegate = habitCreateDelegate {
           // delegate.didCreateHabit(with: trackerCategoryInMain)
        }
        
        finishCreatingHabitAndDismiss()
    }
    
    func finishCreatingHabitAndDismiss() {
        dismiss(animated: false) {
            self.habitCreateDelegate?.didFinishCreatingHabitAndDismiss()
        }
    }
    
    @objc private func buttonActionForHabitCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func firstWayForButtonActionForCreateCategory() {
        let createCategoryButton = AddCategoryViewController()
        createCategoryButton.delegate = self
        present(createCategoryButton, animated: true, completion: nil)
    }
    
    @objc private func buttonActionForCreateSchedule() {
        let createScheduleButton = ScheduleViewController()
        createScheduleButton.delegate = self
        let createScheduleButtonNavigationController = UINavigationController(rootViewController: createScheduleButton)
        present(createScheduleButtonNavigationController, animated: true, completion: nil)
    }
    
    private func setupTableHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 343, height: 1))
        tableView.tableHeaderView = headerView
    }
    
    private func updateCreateButtonState() {
        guard let selectedTrackerName = trackerName.text,
              !selectedTrackerName.isEmpty,
              let selectedCategoryString = selectedCategoryString,
              let selectedEmoji = selectedEmoji,
              let selectedColor = selectedColor,
              !selectedScheduleDays.isEmpty
        else {
            saveButton.isEnabled = false
            return
        }
        
        saveButton.isEnabled = true
        saveButton.backgroundColor = .black
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == trackerName {
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            selectedTrackerName = updatedText
            textField.textColor = .black
            
            updateCreateButtonState()
        }
        return true
    }
}

extension NewHabitCreateViewController: ScheduleViewControllerDelegate {
    
    func didSelectScheduleDays(_ selectedDays: [WeekDay]) {
        let newTrackerRecord = TrackerRecord(date: Date(), trackerId: UUID())
        self.trackerRecord = newTrackerRecord
        self.selectedScheduleDays = selectedDays
        tableView.reloadData()
        updateCreateButtonState()
    }
    
    func didSelectCategory(_ selectedCategory: String?) {
        self.selectedCategoryString = selectedCategory
        tableView.reloadData()
        updateCreateButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc
    private func hideKeyboard() {
        self.scrollContentView.endEditing(true)
    }
}
