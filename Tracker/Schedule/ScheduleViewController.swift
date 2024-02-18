//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Eduard Karimov on 09/12/2023.
//

import UIKit
import Foundation

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectScheduleDays(_ selectedDays: [WeekDay])
}

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    private var selectedDays: [WeekDay] = []
    
    private let selectedDaysKey = "SelectedDaysKey"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(buttonActionForCreateSchedule), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Расписание"
        view.backgroundColor = .white
        
        if let savedDaysData = UserDefaults.standard.data(forKey: selectedDaysKey),
           let savedDays = try? JSONDecoder().decode([WeekDay].self, from: savedDaysData) {
            selectedDays = savedDays
        }
        
        configureTableView()
        configureDoneButton()
        
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.layoutIfNeeded()
    }
    
    private func configureDoneButton() {
        view.addSubview(doneButton)
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
           if let savedDaysData = try? JSONEncoder().encode(selectedDays) {
               UserDefaults.standard.set(savedDaysData, forKey: selectedDaysKey)
           }

           delegate?.didSelectScheduleDays(selectedDays)
           dismiss(animated: true, completion: nil)
       }
}
