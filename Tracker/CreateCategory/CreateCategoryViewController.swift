//
//  CreateCategory.swift
//  Tracker
//
//  Created by Eduard Karimov on 09/12/2023.
//

import UIKit

protocol CreateCategoryViewControllerDelegate: NSObject {
    func didCreatedCategory(_ createdCategory: TrackerCategory, categories: String)
}

final class CreateCategoryViewController: UIViewController, UITextFieldDelegate {
    
    private var category: TrackerCategory?
    private var enteredText: String = ""
    private var createdCategory: String = ""
    
    let labelNewCategory = UILabel()
    let customFontBold = UIFont(name: "SFProDisplay-Medium", size: UIFont.labelFontSize)
    let doneButton = UIButton()
    let categoryName = UITextField()
    
    weak var delegate: CreateCategoryViewControllerDelegate?
    
    var onDismiss: (() -> Void)?
    
    convenience init(delegate: CreateCategoryViewControllerDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = .white
        
        categoryName.delegate = self
                
        labelForCreateNewCategory()
        
        constraitsForLabel()
        
        categoryTextField()
        
        constraitsForCategoryTextField()
        
        doneButtonForScreen()
        
        constraitsForDoneButton()
    }
    
    // MARK: - Screen Config
    
    fileprivate func labelForCreateNewCategory() {
        labelNewCategory.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)).withSize(16)
        labelNewCategory.textColor = .black
        labelNewCategory.text = "Новая категория"
        view.addSubview(labelNewCategory)
    }
    
    fileprivate func constraitsForLabel() {
        //создание констрейтов для лейбла
        labelNewCategory.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelNewCategory.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            labelNewCategory.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    fileprivate func categoryTextField() {
        //создание текстового поля
        categoryName.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        categoryName.placeholder = "Введите название категории"
        categoryName.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        categoryName.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
        categoryName.layer.cornerRadius = 16
        categoryName.clipsToBounds = true
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: categoryName.frame.height))
        categoryName.leftView = leftPaddingView
        categoryName.leftViewMode = .always
        categoryName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        view.addSubview(categoryName)
    }
    
    fileprivate func constraitsForCategoryTextField() {
        // Установка констрейтов для размеров текстового поля
        NSLayoutConstraint.activate([
            categoryName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            categoryName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            categoryName.heightAnchor.constraint(equalToConstant: 75),
            categoryName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryName.topAnchor.constraint(equalTo: labelNewCategory.topAnchor, constant: 38)
        ])
    }
    
    fileprivate func doneButtonForScreen() {
        doneButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.layer.cornerRadius = 16
        doneButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        doneButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        doneButton.isEnabled = false
        
        doneButton.addTarget(self, action: #selector(сreatedCategory), for: .touchUpInside)
        view.addSubview(doneButton)
    }
    
    fileprivate func constraitsForDoneButton() {
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

    // MARK: - Screen Func
    
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
        
        let category = TrackerCategory(label: enteredText, trackerArray: nil)
        
        delegate?.didCreatedCategory(category, categories: createdCategory)
        dismiss(animated: true) {
            self.onDismiss?()
        }
    }
    
    @objc
    private func hideKeyboard() {
        self.view.endEditing(true)
    }
}
