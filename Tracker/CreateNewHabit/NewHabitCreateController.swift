//
//  NewHabitCreateController.swift
//  Tracker
//
//  Created by Eduard Karimov on 26/11/2023.
//

import UIKit

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
        self.view.addGestureRecognizer(tapGesture)
        saveButton.addTarget(self, action: #selector(buttonActionForHabitSave), for: .touchUpInside)
    }
    
    private let emojiCollectionView: UICollectionView = {
        let layoutEmodji = UICollectionViewFlowLayout()
        layoutEmodji.scrollDirection = .horizontal
        let collectionViewEmodji = UICollectionView(frame: .zero, collectionViewLayout: layoutEmodji)
        collectionViewEmodji.translatesAutoresizingMaskIntoConstraints = false
        collectionViewEmodji.backgroundColor = .clear
        collectionViewEmodji.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCell")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerName.delegate = self
        
        view.backgroundColor = .white
        
        configureLabel()
        configureTrackerName()
        configureTableView()
        configerEmodjiLabel()
        configerColorsLabel()
        view.addSubview(colorsCollectionView)
        
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        
        configureButtonsContainer()
        
        updateCreateButtonState()
        
        configereKeyboard()
        configerCollectionViewEmodji()
        configerCollectionViewColor()
    }
    
    // MARK: - Screen Config
    
    private func configureLabel() {
        let customFontBold = UIFont(name: "SFProDisplay-Medium", size: UIFont.labelFontSize)
        label.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)).withSize(16)
        label.textColor = .black
        label.text = "Создание привычки"
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
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
        view.addSubview(trackerName)
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: trackerName.frame.height))
        trackerName.leftView = leftPaddingView
        trackerName.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            trackerName.widthAnchor.constraint(equalToConstant: 343),
            trackerName.heightAnchor.constraint(equalToConstant: 75),
            trackerName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerName.topAnchor.constraint(equalTo: label.topAnchor, constant: 38)
        ])
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
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalToConstant: 343),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: trackerName.bottomAnchor, constant: 24)
        ])
    }
    
    private func configerEmodjiLabel() {
        let customFontBold = UIFont(name: "SFProDisplay-Bold", size: UIFont.labelFontSize)
        labelEmoji.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.semibold)).withSize(19)
        labelEmoji.textColor = .black
        labelEmoji.text = "Emodli"
        view.addSubview(labelEmoji)
        
        labelEmoji.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelEmoji.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            labelEmoji.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28)
        ])
    }
    
    private func configerCollectionViewEmodji() {
        view.addSubview(emojiCollectionView)
        NSLayoutConstraint.activate([
            emojiCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func configerColorsLabel() {
        let customFontBold = UIFont(name: "SFProDisplay-Bold", size: UIFont.labelFontSize)
        labelColors.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.semibold)).withSize(19)
        labelColors.textColor = .black
        labelColors.text = "Цвет"
        view.addSubview(labelColors)
        
        labelColors.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelColors.topAnchor.constraint(equalTo: labelEmoji.bottomAnchor, constant: 200),
            labelColors.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28)
        ])
    }
    
    private func configerCollectionViewColor() {
        NSLayoutConstraint.activate([
            colorsCollectionView.topAnchor.constraint(equalTo: labelEmoji.bottomAnchor, constant: 230),
            colorsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            colorsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func configureButtonsContainer() {
        saveButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        saveButton.setTitle("Создать", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 16
        saveButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        cancelButton.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        cancelButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.layer.cornerRadius = 16
        cancelButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.addTarget(self, action: #selector(buttonActionForHabitCancel), for: .touchUpInside)
        
        let buttonsContainer = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        buttonsContainer.axis = .horizontal
        buttonsContainer.spacing = 16
        buttonsContainer.distribution = .fillEqually
        view.addSubview(buttonsContainer)
        
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsContainer.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 24),
            buttonsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func updateCreateButtonState() {
        guard selectedCategoryString != nil,
              !selectedScheduleDays.isEmpty,
              let trackerNameText = trackerName.text,
              !trackerNameText.isEmpty
        else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
            return
        }
        saveButton.isEnabled = true
        saveButton.backgroundColor = .black
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
                // Настройте ячейку вашего UICollectionView
                // Например, установите эмодзи в ячейке
                cell.backgroundColor = .clear
                cell.contentView.backgroundColor = .clear
                // Установите эмодзи в ячейке
                let emojiLabel = UILabel(frame: cell.bounds)
                emojiLabel.textAlignment = .center
                emojiLabel.text = emojis[indexPath.item]
                emojiLabel.font = UIFont.systemFont(ofSize: 32)
                cell.contentView.addSubview(emojiLabel)
                return cell }
            else if collectionView == colorsCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCell", for: indexPath)
                cell.contentView.backgroundColor = .clear
                cell.layer.cornerRadius = 8
                cell.backgroundColor = tableColors[indexPath.item]
                return cell
            }
            return UICollectionViewCell()
        }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexEmoji.contains(indexPath) { // Проверяем, выбрана ли уже эта ячейка
            // Если выбрана, то убираем выбор и меняем стиль
            selectedIndexEmoji.remove(indexPath)
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 1.0) // Серый цвет #E6E8EB
                cell.contentView.layer.cornerRadius = 16 // Закругленные углы
            }
        } else {
            // Если ячейка не выбрана, то выбираем и меняем стиль
            selectedIndexEmoji.insert(indexPath)
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.backgroundColor = .white
                cell.contentView.layer.cornerRadius = 16 // Закругленные углы
            }
        }
        // Обрабатываем выбор эмодзи
       // let selectedEmoji = emojis[indexPath.item]
        // Можете выполнить какие-то действия с выбранным эмодзи
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    // MARK: - Screen Func
    
    @objc private func buttonActionForHabitSave() {
        guard let selectedTrackerName = trackerName.text, !selectedTrackerName.isEmpty,
              let selectedCategoryString = selectedCategoryString,
              !selectedScheduleDays.isEmpty else {
            return
        }
                
        let tracker = Tracker(id: UUID(), name: selectedTrackerName, color: "", emodji: "", timetable: selectedScheduleDays)
        
        let trackerCategoryInMain = TrackerCategory(label: selectedCategoryString, trackerArray: [tracker])
        
        if let delegate = habitCreateDelegate {
            delegate.didCreateHabit(with: trackerCategoryInMain)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == trackerName {
            textField.textColor = UIColor.black
        }
        updateCreateButtonState()
    }
}

extension NewHabitCreateViewController: ScheduleViewControllerDelegate {
    
    func didSelectScheduleDays(_ selectedDays: [WeekDay]) {
        let newTrackerRecord = TrackerRecord(id: UUID(), date: Date(), selectedDays: selectedDays, trackerId: UUID())
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
        self.view.endEditing(true)
    }
}
