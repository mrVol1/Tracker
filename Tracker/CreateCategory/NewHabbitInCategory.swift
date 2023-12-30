//
//  NewHabbitCategory.swift
//  Tracker
//
//  Created by Eduard Karimov on 09/12/2023.
//

import UIKit

protocol NewHabitCategoryDelegate: AnyObject {
    func didSelectCategory(_ selectedCategory: TrackerCategory)
}

final class NewHabbitCategory: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedCategory: TrackerCategory?
    var textImageBottomAnchor: NSLayoutYAxisAnchor?
    var buttonTopAnchor: NSLayoutConstraint?
    var tableViewHeightAnchor: NSLayoutConstraint?
    weak var delegate: NewHabitCategoryDelegate?
    
    private var selectedCategoryLabel: String?
    
    private var isCellSelected: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // создание лейбла
        let label = UILabel()
        let customFontBold = UIFont(name: "SFProDisplay-Medium", size: UIFont.labelFontSize)
        label.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)).withSize(16)
        label.textColor = .black
        label.text = "Создание категории"
        view.addSubview(label)
        
        // создание констрейтов для лейбла
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // создание таблицы
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        // создание констрейтов для таблицы
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewHeightAnchor = tableView.heightAnchor.constraint(equalToConstant: selectedCategory != nil ? 75 : 0)
        tableViewHeightAnchor?.isActive = true
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        let savedCategories = loadCategoriesFromUserDefaults()
        if let selectedCategory = selectedCategory, savedCategories.contains(selectedCategory) {
            isCellSelected = true
        }
        
        if selectedCategory == nil {
            // дефолтное состояние
            let defaultImageView = UIImageView(image: UIImage(named: "1"))
            view.addSubview(defaultImageView)
            
            defaultImageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                defaultImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                defaultImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
            // добавление текста под картинку
            let textImage = UILabel()
            
            textImage.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)).withSize(12)
            textImage.textColor = .black
            textImage.text = "Привычки и события можно \n объединить по смыслу"
            textImage.numberOfLines = 0
            textImage.textAlignment = .center
            view.addSubview(textImage)
            
            // создание констрейтов для лейбла
            textImage.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                textImage.topAnchor.constraint(equalTo: defaultImageView.bottomAnchor, constant: 32),
                textImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
        
        // создание кнопки
        let categoryButton = UIButton()
        categoryButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        categoryButton.setTitle(selectedCategory != nil ? "Готово" : "Добавить категорию", for: .normal)
        categoryButton.setTitleColor(.white, for: .normal)
        categoryButton.layer.cornerRadius = 16
        categoryButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        categoryButton.backgroundColor = .black
        categoryButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(categoryButton)
        
        // констрейты кнопки
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            categoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            categoryButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            categoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func screenForCreatedCategory() {
        let createCategoryButton = CreateCategory()
        let createCategoryNavigationController = UINavigationController(rootViewController: createCategoryButton)
        present(createCategoryNavigationController, animated: true, completion: nil)
    }
    
    // MARK: - UITableView Data Source and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCategoryTableViewCell
        cell.categoryLabel.text = selectedCategory?.label
        
        // Проверка, содержится ли выбранная категория среди сохраненных
        if let selectedCategory = selectedCategory {
            let savedCategories = loadCategoriesFromUserDefaults()
            isCellSelected = savedCategories.contains { $0.label == selectedCategory.label }
        }
        
        cell.updateCellAppearance(isSelected: isCellSelected)
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Обработка нажатия на ячейку
        if selectedCategory != nil {
            // Если категория не выбрана, выбираем её
            selectedCategoryLabel = selectedCategory?.label
            selectedCategory = TrackerCategory(label: selectedCategoryLabel ?? "", trackerMassiv: [])
            isCellSelected = true
            
            // Сохранение выбранной категории в UserDefaults
            if let selectedCategory = selectedCategory {
                saveCategoryToUserDefaults(selectedCategory)
            }
        }
        
        // Обновление кнопки "Готово" / "Добавить категорию"
        updateCategoryButtonTitle()
    }
    
    
    private func saveCategoryToUserDefaults(_ category: TrackerCategory) {
        // Получение текущего массива категорий из UserDefaults
        let existingCategories = UserDefaults.standard.object(forKey: "Categories") as? Data
        
        if existingCategories == nil {
            // Если массива нет, создайте новый
            let initialCategories = [category]
            do {
                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: initialCategories, requiringSecureCoding: false)
                UserDefaults.standard.set(encodedData, forKey: "Categories")
            } catch {
                print("Error encoding categories: \(error)")
            }
        } else {
            // Если массив уже существует, добавьте новую категорию
            do {
                var decodedCategories = loadCategoriesFromUserDefaults()
                decodedCategories.append(category)
                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: decodedCategories, requiringSecureCoding: false)
                UserDefaults.standard.set(encodedData, forKey: "Categories")
            } catch {
                print("Error decoding or encoding categories: \(error)")
            }
        }
    }
    
    private func loadCategoriesFromUserDefaults() -> [TrackerCategory] {
        guard let categoriesData = UserDefaults.standard.object(forKey: "Categories") as? Data else {
            return []
        }

        do {
            if let categories = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, TrackerCategory.self], from: categoriesData) as? [TrackerCategory] {
                return categories
            }
        } catch {
            print("Error decoding categories: \(error)")
        }

        return []
    }
    
    private func updateCategoryButtonTitle() {
        let categoryButton = view.subviews.compactMap { $0 as? UIButton }.first
        categoryButton?.setTitle(selectedCategory == nil ? "Готово" : "Добавить категорию", for: .normal)
    }
    
    private func navigateToNewHabitCreateController(selectedCategory: TrackerCategory) {
        let newHabitCreateController = NewHabitCreateController()
        newHabitCreateController.selectedCategoryLabel = selectedCategory.label
        
        present(newHabitCreateController, animated: true, completion: nil)
        delegate?.didSelectCategory(selectedCategory)
        
    }
    
    @objc private func buttonAction() {
        if let selectedCategory = selectedCategory {
            // Если категория уже выбрана, передайте ее делегату
            delegate?.didSelectCategory(selectedCategory)
            navigateToNewHabitCreateController(selectedCategory: selectedCategory)
        } else {
            // Если категория не выбрана, откройте экран создания категории
            screenForCreatedCategory()
        }
    }}
