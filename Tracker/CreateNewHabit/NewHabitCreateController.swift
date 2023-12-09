//
//  NewHabitCreateController.swift
//  Tracker
//
//  Created by Eduard Karimov on 26/11/2023.
//

import UIKit

final class NewHabitCreateController: UIViewController {
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
        
        
        //кнопка "Категории"
        
        let categoryButton = UIButton()
        categoryButton.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        categoryButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        categoryButton.setTitle("Категория", for: .normal)
        categoryButton.setTitleColor(.black, for: .normal)
        categoryButton.setImage(UIImage(systemName: "arrow.right")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        categoryButton.layer.cornerRadius = 16
        categoryButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -240, bottom: 0, right: 0)
        categoryButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -240)
        
        categoryButton.semanticContentAttribute = .forceRightToLeft
        categoryButton.clipsToBounds = true
        categoryButton.addTarget(self, action: #selector(buttonActionForCreateCategory), for: .touchUpInside)
        view.addSubview(categoryButton)
        
        // Установка констрейнтов для кнопки
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryButton.bottomAnchor.constraint(equalTo: trackerName.bottomAnchor, constant: 78),
            categoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        //кнопка "расписание"
        
        let timeButton = UIButton()
        timeButton.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        timeButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        timeButton.setTitle("Расписание", for: .normal)
        timeButton.setTitleColor(.black, for: .normal)
        timeButton.setImage(UIImage(systemName: "arrow.right")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        timeButton.layer.cornerRadius = 16
        timeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -230, bottom: 0, right: 0)
        timeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -230)
        
        timeButton.semanticContentAttribute = .forceRightToLeft
        timeButton.clipsToBounds = true
        timeButton.addTarget(self, action: #selector(buttonActionForCreateSculde), for: .touchUpInside)
        view.addSubview(timeButton)
        
        // Установка констрейнтов для кнопки
        timeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeButton.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 64),
            timeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            timeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            timeButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
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
            saveButton.bottomAnchor.constraint(equalTo: timeButton.bottomAnchor, constant: 420),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        //кнопка "отмена"
        
        let cancelButton = UIButton()
        //cancelButton.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
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


