//
//  NewEventCreateController.swift
//  Tracker
//
//  Created by Eduard Karimov on 03/04/2024.
//

import UIKit

enum TableSectionForEvent: Int, CaseIterable {
    case categoriesEvent
}

protocol NewEventCreateViewControllerDelegate: AnyObject {
    func didCreateEvent(with trackerCategoryInMain: TrackerCategory)
    func didFinishCreatingEventAndDismiss()
}

final class NewEventCreateViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, AddCategoryViewControllerDelegate {
    
    var selectedCategoryStringForEvent: String?
    var selectedTrackerNameForEvent: String?
    var cellWithCategoryLabel: CategoryTableViewCellForEvent?

    weak var eventCreateDelegate: NewEventCreateViewControllerDelegate?
    weak var addCategoryDelegate: AddCategoryViewControllerDelegate?
    
    let label = UILabel()
    let trackerName = UITextField()
    let saveButton = UIButton()
    let cancelButton = UIButton()
    let tableView = UITableView()
    
    fileprivate func configereKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        saveButton.addTarget(self, action: #selector(buttonActionForEventSave), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerName.delegate = self
        
        view.backgroundColor = .white
        
        configureLabel()
        configureTrackerName()
        configureTableView()
        configureButtonsContainer()
        
        updateCreateButtonState()
        
        configereKeyboard()
    }
    
    
    // MARK: - Screen Config
    
    private func configureLabel() {
        let customFontBold = UIFont(name: "SFProDisplay-Medium", size: UIFont.labelFontSize)
        label.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)).withSize(16)
        label.textColor = .black
        label.text = "Новое нерегулярное событие"
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
        tableView.isScrollEnabled = false
        
        tableView.register(CategoryTableViewCellForEvent.self, forCellReuseIdentifier: "categoryCell")
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalToConstant: 343),
            tableView.heightAnchor.constraint(equalToConstant: 75),
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
        cancelButton.addTarget(self, action: #selector(buttonActionForEventCancel), for: .touchUpInside)
        
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
    
    private func updateCreateButtonState() {
        guard selectedCategoryStringForEvent != nil,
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TableSectionForEvent(rawValue: indexPath.section) else {
            return CategoryTableViewCellForEvent()
        }
        
        let cell: CategoryTableViewCellForEvent
        
        if section == .categoriesEvent {
            cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCellForEvent
            cell.titleLabel.text = "Категории"
            cell.titleLabel.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1.0)
            cell.titleLabel.textAlignment = .center
            cell.accessoryType = .disclosureIndicator
            
            if let selectedCategoryStringForEvent = selectedCategoryStringForEvent {
                cell.categoryLabel.text = selectedCategoryStringForEvent
                cell.categoryLabel.isHidden = false
            } else {
                cell.categoryLabel.text = ""
                cell.categoryLabel.isHidden = true
            }
            
            cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
            cellWithCategoryLabel = cell
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        firstWayForButtonActionForCreateCategory()
    }
    
    // MARK: - Screen Func
    
    @objc private func buttonActionForEventSave() {
        guard let selectedTrackerName = trackerName.text, !selectedTrackerName.isEmpty,
              let selectedCategoryStringForEvent = selectedCategoryStringForEvent
        else {
            return
        }
                
        let tracker = Tracker(id: UUID(), name: selectedTrackerName, color: "", emodji: "", timetable: [])
        
        let trackerCategoryInMain = TrackerCategory(label: selectedCategoryStringForEvent, trackerArray: [tracker])
        
        if let delegate = eventCreateDelegate {
            delegate.didCreateEvent(with: trackerCategoryInMain)
        }
        
        finishCreatingEventAndDismiss()
    }
    
    func finishCreatingEventAndDismiss() {
        dismiss(animated: false) {
            self.eventCreateDelegate?.didFinishCreatingEventAndDismiss()
        }
    }
    
    @objc private func buttonActionForEventCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func firstWayForButtonActionForCreateCategory() {
        let createCategoryButton = AddCategoryViewController()
        createCategoryButton.delegate = self
        present(createCategoryButton, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == trackerName {
            textField.textColor = UIColor.black
        }
        updateCreateButtonState()
    }
    
    func didSelectCategory(_ selectedCategory: String?) {
        self.selectedCategoryStringForEvent = selectedCategory
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
