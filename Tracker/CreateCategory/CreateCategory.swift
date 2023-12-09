//
//  CreateCategory.swift
//  Tracker
//
//  Created by Eduard Karimov on 09/12/2023.
//

import UIKit

final class CreateCategory: UIViewController, UITextFieldDelegate {
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
        let categoryName = UITextField()
        
        categoryName.delegate = self
        categoryName.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        categoryName.placeholder = "Введите название категории"
        categoryName.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        categoryName.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
        categoryName.layer.cornerRadius = 16
        categoryName.clipsToBounds = true
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryName)
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: categoryName.frame.height))
        categoryName.leftView = leftPaddingView
        categoryName.leftViewMode = .always
        
        // Установка констрейтов для размеров текстового поля
        NSLayoutConstraint.activate([
            categoryName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            categoryName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            categoryName.heightAnchor.constraint(equalToConstant: 75),
            categoryName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryName.topAnchor.constraint(equalTo: labelNewCategory.topAnchor, constant: 38)
        ])
        
        //кнопка "Готово"
        let doneButton = UIButton()
        doneButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.layer.cornerRadius = 16
        doneButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        doneButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        doneButton.isEnabled = false
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
        
        func categoryName(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let newLength = (textField.text?.count ?? 0) + string.count - range.length
            doneButton.isEnabled = newLength > 0
            
            doneButton.backgroundColor = doneButton.isEnabled ? .black : UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)

            return true
        }
    }
    @objc func сreatedCategory() {
        print("Кнопка нажата")
    }
}
