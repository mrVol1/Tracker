//
//  CreateCategory.swift
//  Tracker
//
//  Created by Eduard Karimov on 09/12/2023.
//

import UIKit

final class CreateCategory: UIViewController, UITextFieldDelegate, NewHabbitCategoryDelegate {
    
    private var category: TrackerCategory?
    private var enteredText: String = ""
    
    weak var delegate: NewHabbitCategoryDelegate?
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        button.isEnabled = false
        return button
    }()
    
    private let categoryName: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        textField.placeholder = "Введите название категории"
        textField.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        textField.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
        textField.layer.cornerRadius = 16
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    convenience init(delegate: NewHabbitCategoryDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        //создание лейбла
        let labelNewCategory = UILabel()
        
        let customFontBold = UIFont(name: "SFProDisplay-Medium", size: UIFont.labelFontSize)
        labelNewCategory.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)).withSize(16)
        labelNewCategory.textColor = .black
        labelNewCategory.text = "Новая категория"
        view.addSubview(labelNewCategory)
        
        //создание констрейтов для лейбла
        labelNewCategory.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelNewCategory.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            labelNewCategory.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        //создание текстового поля
        view.addSubview(categoryName)
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: categoryName.frame.height))
        categoryName.leftView = leftPaddingView
        categoryName.leftViewMode = .always
        categoryName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Установка констрейтов для размеров текстового поля
        NSLayoutConstraint.activate([
            categoryName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            categoryName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            categoryName.heightAnchor.constraint(equalToConstant: 75),
            categoryName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryName.topAnchor.constraint(equalTo: labelNewCategory.topAnchor, constant: 38)
        ])
        
        //кнопка "Готово"
        doneButton.addTarget(self, action: #selector(сreatedCategory), for: .touchUpInside)
        view.addSubview(doneButton)
        
        //констрейты кнопки
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
    
    func didSelectCategory(_ selectedCategory: TrackerCategory) {
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        enteredText = textField.text ?? ""
        doneButton.isEnabled = !enteredText.isEmpty
        doneButton.backgroundColor = doneButton.isEnabled ? .black : UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        categoryName.textColor = enteredText.isEmpty ? UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0) : .black
    }
    
    @objc func сreatedCategory() {
        guard let enteredText = categoryName.text, !enteredText.isEmpty else {
            return
        }
        
        let tracker = Tracker(id: 1, name: "", color: "", emodji: "", timetable: "")
        let category = TrackerCategory(label: enteredText, trackerMassiv: [tracker])
        
        // Возможно, вам нужно что-то сделать с category здесь, например, добавить его в массив категорий
        // categoriesArray.append(category)
        
        let newHabbitCategoryScreen = NewHabbitCategory()
        newHabbitCategoryScreen.selectedCategory = category
        newHabbitCategoryScreen.delegate = self
        
        // Передача делегата
        delegate?.didSelectCategory(category)
        present(newHabbitCategoryScreen, animated: true) {
        }
    }
}
