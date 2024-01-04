//
//  NewHabbitCategory.swift
//  Tracker
//
//  Created by Eduard Karimov on 09/12/2023.
//

import UIKit

protocol NewHabbitCategoryDelegate: AnyObject {
    func didSelectCategory(_ selectedCategory: TrackerCategory)
}

final class NewHabbitCategory: UIViewController, UITableViewDelegate, UITableViewDataSource, NewHabbitCategoryDelegate {
    
    weak var delegate: NewHabbitCategoryDelegate? {
        didSet {
            print("Delegate set")
        }
    }
    var selectedCategory: TrackerCategory?
    var textImageBottomAnchor: NSLayoutYAxisAnchor?
    var buttonTopAnchor: NSLayoutConstraint?
    var tableViewHeightAnchor: NSLayoutConstraint?
    
    private var selectedCategoryLabel: String?
    
    private var isCellSelected: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad. Delegate: \(String(describing: delegate))")

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
        categoryButton.addTarget(self, action: #selector(screenForCreatedCategory), for: .touchUpInside)
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
    
    // MARK: - UITableView Data Source and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCategoryTableViewCell
        cell.categoryLabel.text = selectedCategory?.label
        cell.updateCellAppearance(isSelected: isCellSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let delegate = delegate {
                delegate.didSelectCategory(selectedCategory!)
                print("Delegate is not nil")
            } else {
                print("Delegate is nil")
            }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Обработка нажатия на ячейку
        isCellSelected = !isCellSelected
        
        if isCellSelected {
            // Если категория не выбрана, выбираем её
            selectedCategoryLabel = selectedCategory?.label
            selectedCategory = TrackerCategory(label: selectedCategoryLabel ?? "", trackerMassiv: [])
        } else {
            // Если категория уже выбрана, снимаем выбор
            selectedCategory = nil
        }
        
        // Обновление кнопки "Готово" / "Добавить категорию"
        updateCategoryButtonTitle()
        print("Did select row at indexPath: \(indexPath)")
        if let delegate = delegate {
            delegate.didSelectCategory(selectedCategory!)
        } else {
            print("Delegate is nil")
        }
    }
    
    func didSelectCategory(_ selectedCategory: TrackerCategory) {
        print("Delegate method didSelectCategory called with category: \(selectedCategory)")
        
        // Опционально представить NewHabitCreateController
        if let presentedController = presentedViewController,
            !(presentedController is NewHabitCreateController || presentedController is UINavigationController) {
            navigateToNewHabitCreateController(selectedCategory: selectedCategory)
        }
        
        // Продолжить обработку выбора категории, если необходимо
    }

    private func navigateToNewHabitCreateController(selectedCategory: TrackerCategory) {
        print("Navigating to NewHabitCreateController with category: \(selectedCategory)")
        
        // Проверяем, представлен ли NewHabitCreateController или UINavigationController
        if let presentedController = presentedViewController as? NewHabitCreateController {
            print("NewHabitCreateController is already presented")
            presentedController.selectedCategoryLabel = selectedCategory.label
            delegate?.didSelectCategory(selectedCategory)
        } else {
            print("Presenting NewHabitCreateController")
            
            let newHabitCreateController = NewHabitCreateController()
            newHabitCreateController.selectedCategoryLabel = selectedCategory.label

            // Проверяем, есть ли у нас UINavigationController, иначе представляем просто контроллер
            if let navigationController = self.navigationController {
                navigationController.present(newHabitCreateController, animated: true, completion: nil)
            } else {
                present(newHabitCreateController, animated: true, completion: nil)
            }
            
            delegate?.didSelectCategory(selectedCategory)
        }
    }


    
    private func updateCategoryButtonTitle() {
        let categoryButton = view.subviews.compactMap { $0 as? UIButton }.first
        categoryButton?.setTitle(selectedCategory != nil ? "Готово" : "Добавить категорию", for: .normal)
    }

    @objc private func screenForCreatedCategory() {
        if let selectedCategory = selectedCategory {
            // Если категория уже выбрана, передайте ее делегату
            delegate?.didSelectCategory(selectedCategory)
            navigateToNewHabitCreateController(selectedCategory: selectedCategory)
        } else {
            // Если категория не выбрана, откройте экран создания категории
            let createCategoryButton = CreateCategory(delegate: self)  // Здесь делегат устанавливается как self
            let createCategoryNavigationController = UINavigationController(rootViewController: createCategoryButton)
            createCategoryButton.delegate = self
            present(createCategoryNavigationController, animated: true, completion: nil)
        }
        print("Button tapped")
    }
}
