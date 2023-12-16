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

final class NewHabitCreateController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableSection(rawValue: section) {
        case .categories:
            return 1
        case .schedule:
            return 1
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ""
        
        switch TableSection(rawValue: indexPath.section) {
        case .categories:
            cell.textLabel?.text = "Категории"
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        case .schedule:
            cell.textLabel?.text = "Расписание"
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        case .none:
            break
        }
        return cell
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
            buttonActionForCreateSculde()
        case .none:
            break
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.sectionHeaderHeight = 0
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        //создание лейбла
        let label = UILabel()
        
        let customFontBold = UIFont(name: "SFProDisplay-Medium", size: UIFont.labelFontSize)
        label.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)).withSize(16)
        label.textColor = .black
        label.text = "Создание привычки"
        view.addSubview(label)
        
        //создание констрейтов для лейбла
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        //создание текстового поля
        let trackerName = UITextField()
        
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
        
        // Установка констрейтов для размеров текстового поля
        NSLayoutConstraint.activate([
            trackerName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            trackerName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            trackerName.heightAnchor.constraint(equalToConstant: 75),
            trackerName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerName.topAnchor.constraint(equalTo: label.topAnchor, constant: 38)
        ])
        
        //таблица с кнопками
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        // Добавление необходимых констрейнтов для tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let cellHeight: CGFloat = 75
        let tableHeight = 2 * cellHeight
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: trackerName.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: tableHeight),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        //установка разделителя между ячейками
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0

        //кнопка "сохранить"
        
        let saveButton = UIButton()
        saveButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        saveButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        saveButton.setTitle("Создать", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 16
        saveButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        view.addSubview(saveButton)
        
        // Установка констрейнтов для кнопки
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        //кнопка "отмена"
        
        let cancelButton = UIButton()
        cancelButton.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        cancelButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.layer.cornerRadius = 16
        cancelButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.addTarget(self, action: #selector(buttonActionForHabbitCancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        // Установка констрейнтов для кнопки
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 64),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    @objc private func buttonActionForHabbitCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func buttonActionForCreateCategory() {
        let createCategoryButton = NewHabbitCategory()
        let createCategotuButtonNavigationController = UINavigationController(rootViewController: createCategoryButton)
        present(createCategotuButtonNavigationController, animated: true, completion: nil)
    }
    
    @objc private func buttonActionForCreateSculde() {
        let createScheduleButton = ScheduleViewController()
        let createScheduleButtonNavigationController = UINavigationController(rootViewController: createScheduleButton)
        present(createScheduleButtonNavigationController, animated: true, completion: nil)
    }
}


