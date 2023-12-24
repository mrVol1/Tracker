//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Eduard Karimov on 09/12/2023.
//

import UIKit

enum WeekDay: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
}

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var selectedDays: [WeekDay] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        return tableView
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.backgroundColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Расписание"
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        tableView.tableFooterView = footerView
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.layer.cornerRadius = 16
        
        // Добавление необходимых констрейнтов для tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -168),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // Установка поведения отступов контента
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.layoutIfNeeded()
        
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(buttonActionForCreateSchedule), for: .touchUpInside)
        //констрейты кнопки
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let day = WeekDay.allCases[indexPath.row]
        cell.textLabel?.text = day.rawValue
        
        cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        
        let switchView = UISwitch()
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        switchView.onTintColor = UIColor.blue
        cell.accessoryView = switchView
        
        switchView.isOn = selectedDays.contains(day)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @objc private func switchChanged(sender: UISwitch) {
        let day = WeekDay.allCases[sender.tag]
        
        if sender.isOn {
            selectedDays.append(day)
        } else {
            selectedDays.removeAll { $0 == day }
        }
    }
    
    @objc private func buttonActionForCreateSchedule() {
        let buttonDoneScheldule = NewHabitCreateController()
        let buttonDoneSchelduleNavigationController = UINavigationController(rootViewController: buttonDoneScheldule)
        present(buttonDoneSchelduleNavigationController, animated: true, completion: nil)
    }
}

