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
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Расписание"
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        // Добавление необходимых констрейнтов для tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // Установка поведения отступов контента
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.layoutIfNeeded()
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
        
        let switchView = UISwitch()
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
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
}
