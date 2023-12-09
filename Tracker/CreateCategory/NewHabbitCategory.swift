//
//  NewHabbitCategory.swift
//  Tracker
//
//  Created by Eduard Karimov on 09/12/2023.
//

import UIKit

final class NewHabbitCategory: UIViewController {
    var selectedCategory: TrackerCategory?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        //создание лейбла
        let label = UILabel()
        
        let customFontBold = UIFont(name: "SFProDisplay-Medium", size: UIFont.labelFontSize)
        label.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)).withSize(16)
        label.textColor = .black
        label.text = "Создание категории"
        view.addSubview(label)
    
        //создание констрейтов для лейбла
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        if let category = selectedCategory {
            let categoryText = UILabel()
            categoryText.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)).withSize(16)
            categoryText.textColor = .black
            categoryText.text = category.label
            view.addSubview(categoryText)
            
            categoryText.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                categoryText.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
                categoryText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
        } else {
            let defaultImageView = UIImageView(image: UIImage(named: "1"))
            view.addSubview(defaultImageView)
            
            defaultImageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                defaultImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                defaultImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
            //добавление текста под картинку
            let textImage = UILabel()
            
            textImage.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)).withSize(12)
            textImage.textColor = .black
            textImage.text = "Привычки и события можно \n объединить по смыслу"
            textImage.numberOfLines = 0
            textImage.textAlignment = .center
            view.addSubview(textImage)
            
            //создание констрейтов для лейбла
            textImage.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                textImage.bottomAnchor.constraint(equalTo: defaultImageView.bottomAnchor, constant: 32),
                textImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
        
        //добавление кнопки
        let categoryButton = UIButton()
        categoryButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        categoryButton.setTitle("Добавить категорию", for: .normal)
        categoryButton.setTitleColor(.white, for: .normal)
        categoryButton.layer.cornerRadius = 16
        categoryButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        categoryButton.backgroundColor = .black
        categoryButton.addTarget(self, action: #selector(screenForCreatedCategory), for: .touchUpInside)
        view.addSubview(categoryButton)
        
        //констрейты кнопки
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        categoryButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        NSLayoutConstraint.activate([
            categoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36),
            categoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            categoryButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
    @objc private func screenForCreatedCategory() {
        let createCategoryButton = CreateCategory()
        let createCategoryNavigationController = UINavigationController(rootViewController: createCategoryButton)
        present(createCategoryNavigationController, animated: true, completion: nil)
    }
}
