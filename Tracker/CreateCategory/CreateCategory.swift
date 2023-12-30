//
//  CreateCategory.swift
//  Tracker
//
//  Created by Eduard Karimov on 09/12/2023.
//

import UIKit

final class CreateCategory: UIViewController, UITextFieldDelegate {
    
    private var category: TrackerCategory?
    private var enteredText: String = ""
    
    // Assuming these properties are defined in your class
    private var selectedCategory: TrackerCategory?
    private var savedCategories: [TrackerCategory] = []
    
    weak var delegate: NewHabitCategoryDelegate? // Add this delegate property
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        if let selectedCategory = selectedCategory, savedCategories.contains(where: { $0.label == selectedCategory.label }) {
            // Handle the case where selectedCategory is already in savedCategories
        }
        
        let labelNewCategory = UILabel()
        labelNewCategory.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        labelNewCategory.textColor = .black
        labelNewCategory.text = "Новая категория"
        view.addSubview(labelNewCategory)
        
        labelNewCategory.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelNewCategory.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            labelNewCategory.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(categoryName)
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: categoryName.frame.height))
        categoryName.leftView = leftPaddingView
        categoryName.leftViewMode = .always
        categoryName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        categoryName.textColor = .black
        
        NSLayoutConstraint.activate([
            categoryName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            categoryName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            categoryName.heightAnchor.constraint(equalToConstant: 75),
            categoryName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryName.topAnchor.constraint(equalTo: labelNewCategory.topAnchor, constant: 38)
        ])
        
        doneButton.addTarget(self, action: #selector(createdCategory), for: .touchUpInside)
        view.addSubview(doneButton)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        enteredText = textField.text ?? ""
        doneButton.isEnabled = !enteredText.isEmpty
        doneButton.backgroundColor = doneButton.isEnabled ? .black : UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
    }
    
    @objc func createdCategory() {
        guard let enteredText = categoryName.text, !enteredText.isEmpty else {
            return
        }
        
        let category = TrackerCategory(label: enteredText, trackerMassiv: [])
        saveCategoryToUserDefaults(category)
        
        delegate?.didSelectCategory(category)
        
        let newHabitCategoryScreen = NewHabbitCategory()
        newHabitCategoryScreen.selectedCategory = category
        
        present(newHabitCategoryScreen, animated: true)
    }
    
    private func saveCategoryToUserDefaults(_ category: TrackerCategory) {
        let existingCategories = UserDefaults.standard.object(forKey: "Categories") as? Data
        
        if existingCategories == nil {
            let initialCategories = [category]
            do {
                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: initialCategories, requiringSecureCoding: false)
                UserDefaults.standard.set(encodedData, forKey: "Categories")
            } catch {
                print("Error encoding categories: \(error)")
            }
        } else {
            do {
                var decodedCategories = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: existingCategories!) as? [TrackerCategory] ?? []
                decodedCategories.append(category)
                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: decodedCategories, requiringSecureCoding: false)
                UserDefaults.standard.set(encodedData, forKey: "Categories")
            } catch {
                print("Error decoding categories: \(error)")
            }
        }
    }
}
