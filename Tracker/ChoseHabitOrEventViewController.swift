//
//  NewHabitController.swift
//  Tracker
//
//  Created by Eduard Karimov on 26/11/2023.
//

import UIKit

protocol ChoseHabitOrEventViewControllerDelegate: AnyObject {
    func didFinishCreatingHabitAndDismiss()
}

final class ChoseHabitOrEventViewController: UIViewController, NewHabitCreateViewControllerDelegate {
    
    let label = UILabel()
    let customFontBold = UIFont(name: "SFProDisplay-Medium", size: UIFont.labelFontSize)
    let habbitButton = UIButton()
    let eventButton = UIButton()
        
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        createLabel()
        constraitForLabel()
        createHabbitButton()
        constraitsForHabbitButton()
        createEventButton()
        constraitsForEventButton()
    }
    // MARK: - Screen Config
    
    fileprivate func createLabel() {
        //создание лейбла
        label.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)).withSize(16)
        label.textColor = .black
        label.text = "Создание трекера"
        view.addSubview(label)
    }
    
    fileprivate func constraitForLabel() {
        //создание констрейтов для лейбла
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    fileprivate func createHabbitButton() {
        habbitButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        habbitButton.setTitle("Привычка", for: .normal)
        habbitButton.setTitleColor(.white, for: .normal)
        habbitButton.layer.cornerRadius = 16
        habbitButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        habbitButton.backgroundColor = .black
        habbitButton.addTarget(self, action: #selector(buttonActionForCreateHabbit), for: .touchUpInside)
        view.addSubview(habbitButton)
    }
    
    fileprivate func constraitsForHabbitButton() {
        habbitButton.translatesAutoresizingMaskIntoConstraints = false
        habbitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        NSLayoutConstraint.activate([
            habbitButton.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 300),
            habbitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habbitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            habbitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
    
    fileprivate func createEventButton () {
        eventButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        eventButton.setTitle("Нерегулярные события", for: .normal)
        eventButton.setTitleColor(.white, for: .normal)
        eventButton.layer.cornerRadius = 16
        eventButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        eventButton.backgroundColor = .black
        view.addSubview(eventButton)
    }
    
    fileprivate func constraitsForEventButton() {
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        eventButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        NSLayoutConstraint.activate([
            eventButton.bottomAnchor.constraint(equalTo: habbitButton.bottomAnchor, constant: 64),
            eventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            eventButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
    
    func didFinishCreatingHabitAndDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func didCreateHabit(withCategoryLabel selectedCategoryString: String?, 
                        selectedScheduleDays: [WeekDay]?,
                        trackerName: String?) {
    }
    
    // MARK: - Screen Func
    
    @objc private func buttonActionForCreateHabbit() {
        let createHabbitbutton = NewHabitCreateViewController()
        createHabbitbutton.habitCreateDelegate = self
        let createNewHabbitButtonNavigationController = UINavigationController(rootViewController: createHabbitbutton)
        present(createNewHabbitButtonNavigationController, animated: true, completion: nil)
    }
}
