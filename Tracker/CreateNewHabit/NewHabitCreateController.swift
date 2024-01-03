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

final class NewHabitCreateController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var selectedCategoryLabel: String?
    var selectedScheduleDays: [WeekDay] = []
    var selectedTrackerName: String?
    weak var scheduleDelegate: ScheduleViewControllerDelegate?
    
    let label = UILabel()
    let trackerName = UITextField()
    let saveButton = UIButton()
    let cancelButton = UIButton()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.sectionHeaderHeight = 0
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureLabel()
        configureTrackerName()
        configureTableView()
        configureButtonsContainer()
        
        updateCreateButtonState()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == trackerName {
            textField.textColor = UIColor.black
        }
        updateCreateButtonState()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableSection(rawValue: indexPath.section) {
        case .categories:
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
            cell.titleLabel.text = "Категории"
            cell.titleLabel.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1.0)
            cell.titleLabel.textAlignment = .center
            cell.accessoryType = .disclosureIndicator
            
            if let selectedCategoryLabel = selectedCategoryLabel {
                cell.categoryLabel.text = selectedCategoryLabel
                saveButton.backgroundColor = .black
                saveButton.addTarget(self, action: #selector(buttonActionForHabitSave), for: .touchUpInside)
            } else {
                cell.categoryLabel.removeFromSuperview()
                saveButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
            }
            
            cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
            return cell
            
        case .schedule:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryTableViewCell
            cell.titleLabel.text = "Расписание"
            cell.titleLabel.textColor = .black
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
            
            if !selectedScheduleDays.isEmpty {
                let scheduleText = selectedScheduleDays.map { $0.rawValue.prefix(2) }.joined(separator: ", ")
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
            buttonActionForCreateCategory()
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
    
    @objc private func buttonActionForHabitSave() {
        let trackerViewController = TrackerViewController(categories: [], completedTrackers: [], newCategories: [])
        trackerViewController.selectedCategoryLabel = selectedCategoryLabel
        trackerViewController.loadCategories()
        let newHabitCreatedButton = UINavigationController(rootViewController: trackerViewController)
        present(newHabitCreatedButton, animated: true, completion: nil)
    }
    
    @objc private func buttonActionForHabitCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func buttonActionForCreateCategory() {
        let createCategoryButton = NewHabbitCategory()
        present(createCategoryButton, animated: true, completion: nil)
    }
    
    @objc private func buttonActionForCreateSchedule() {
        let createScheduleButton = ScheduleViewController()
        createScheduleButton.delegate = self
        let createScheduleButtonNavigationController = UINavigationController(rootViewController: createScheduleButton)
        present(createScheduleButtonNavigationController, animated: true, completion: nil)
    }
    
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
        setupTableHeader()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "categoryCell")
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "daysLabel")
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
            buttonsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupTableHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 343, height: 1))
        tableView.tableHeaderView = headerView
    }
    
    private func updateCreateButtonState() {
        guard let selectedCategoryLabel = selectedCategoryLabel,
              !selectedScheduleDays.isEmpty,
              let trackerNameText = trackerName.text, !trackerNameText.isEmpty else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
            return
        }

        saveButton.isEnabled = true
        saveButton.backgroundColor = .black
    }
}

extension NewHabitCreateController: ScheduleViewControllerDelegate {
    
    func didSelectScheduleDays(_ selectedDays: [WeekDay]) {
        self.selectedScheduleDays = selectedDays
        tableView.reloadData()
        updateCreateButtonState()
    }
    
    func didSelectCategory(_ selectedCategory: TrackerCategory) {
        self.selectedCategoryLabel = selectedCategory.label
        tableView.reloadData()
        updateCreateButtonState()
    }
}
