//
//  NewHabbitCategory.swift
//  Tracker
//
//  Created by Eduard Karimov on 09/12/2023.
//

import UIKit

protocol AddCategoryViewControllerDelegate: AnyObject {
    func didSelectCategory(_ selectedCategory: TrackerCategory)
    func didCreateTrackerRecord(_ trackerRecord: TrackerRecord)
}

final class AddCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CategoryCellTableViewCellDelegate, CreateCategoryViewControllerDelegate {
    
    weak var delegate: AddCategoryViewControllerDelegate? {
        didSet {
        }
    }
    
    let customFontBold = UIFont(name: "SFProDisplay-Medium", size: UIFont.labelFontSize)
    let defaultImageView = UIImageView(image: UIImage(named: "1"))
    let textImage = UILabel()
    
    var createdCategory: TrackerCategory?
    var textImageBottomAnchor: NSLayoutYAxisAnchor?
    var buttonTopAnchor: NSLayoutConstraint?
    var tableViewHeightAnchor: NSLayoutConstraint?
    var categoriesList: [TrackerCategory] = []
    
    private var isCheckmarkSelected: Bool = false
    private var createdCategoryName: String?
    private var isCellSelected: Bool = false
    private let label = UILabel()
    private let tableView = UITableView()
    private let categoryButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        creatLabel()
        constraitsForLabel(label)
        createdTableForCategoriesList()
        constraitsForTableForCategoriesList(label)
        defaultImage()
        defaultText()
        constraitsForDefaultText()
        setupButtonCreated()
        constraitsForSetupButton()
    }
    
    fileprivate func constraitsForLabel(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    fileprivate func createdTableForCategoriesList() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryCellTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    fileprivate func constraitsForTableForCategoriesList(_ label: UILabel) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 16),
        ])
    }
    
    // MARK: - Screen Config
    
    fileprivate func creatLabel() {
        // создание лейбла
        label.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)).withSize(16)
        label.textColor = .black
        label.text = "Создание категории"
        view.addSubview(label)
    }
    
    fileprivate func setupButtonCreated() {
        categoryButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)).withSize(16)
        categoryButton.setTitle("Добавить категорию", for: .normal)
        categoryButton.setTitleColor(.white, for: .normal)
        categoryButton.layer.cornerRadius = 16
        categoryButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        categoryButton.backgroundColor = .black
        categoryButton.addTarget(self, action: #selector(screenForCreatedCategory), for: .touchUpInside)
        view.addSubview(categoryButton)
    }
    
    fileprivate func constraitsForSetupButton() {
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
    
    fileprivate func defaultImage() {
        view.addSubview(defaultImageView)
        defaultImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            defaultImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            defaultImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    fileprivate func defaultText() {
        textImage.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)).withSize(12)
        textImage.textColor = .black
        textImage.text = "Привычки и события можно \n объединить по смыслу"
        textImage.numberOfLines = 0
        textImage.textAlignment = .center
        view.addSubview(textImage)
    }
    
    fileprivate func constraitsForDefaultText() {
        textImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textImage.topAnchor.constraint(equalTo: defaultImageView.bottomAnchor, constant: 32),
            textImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    
    // MARK: - UITableView Data Source and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryCellTableViewCell
        cell.delegate = self
        cell.categoryLabel.text = categoriesList[indexPath.row].label
        cell.updateCheckmarkAppearance(isSelected: isCellSelected)
        return cell
    }
    
    func cellSelectionChanged(isSelected: Bool) {
        isCellSelected = isSelected
        updateCategoryButtonTitle()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isCellSelected {
            createdCategoryName = createdCategory?.label
            createdCategory = categoriesList[indexPath.row]
        }
        
        updateCategoryButtonTitle()
        
        if let delegate = delegate,
            let selectedCategory = createdCategory {
            delegate.didSelectCategory(selectedCategory)
        }
    }
    
    func cellUpdateCheckmarkAppearance(isSelected: Bool) {
        if isSelected == true {
            isCheckmarkSelected = true
        } else {
            isCheckmarkSelected = false
        }
        updateCategoryButtonTitle()
    }
    
    // MARK: - Screen Func

    func didCreatedCategory(_ createdCategory: TrackerCategory) {
        categoriesList.append(createdCategory)
        delegate?.didSelectCategory(createdCategory)
        tableView.reloadData()
    }
    
    private func navigateToNewHabitCreateController(selectedCategory: TrackerCategory) {
        
        if let presentedController = presentedViewController as? NewHabitCreateViewController {
            presentedController.selectedCategoryString = selectedCategory.label
            delegate?.didSelectCategory(selectedCategory)
        } else {
            
            let newHabitCreateController = NewHabitCreateViewController()
            newHabitCreateController.selectedCategoryString = selectedCategory.label
            
            if let navigationController = self.navigationController {
                navigationController.present(newHabitCreateController, animated: true, completion: nil)
            } else {
                present(newHabitCreateController, animated: true, completion: nil)
            }
            
            delegate?.didSelectCategory(selectedCategory)
        }
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func updateCategoryButtonTitle() {
        let categoryButton = view.subviews.compactMap { $0 as? UIButton }.first
        categoryButton?.setTitle(isCheckmarkSelected ? "Готово" : "Добавить категорию", for: .normal)
    }
    
    @objc private func screenForCreatedCategory() {
        if isCheckmarkSelected == true {
            delegate?.didSelectCategory(createdCategory!)
            navigateToNewHabitCreateController(selectedCategory: createdCategory!)
        } else {
            let createCategoryButton = CreateCategoryViewController(delegate: self)
            let createCategoryNavigationController = UINavigationController(rootViewController: createCategoryButton)
            createCategoryButton.delegate = self
            present(createCategoryNavigationController, animated: true, completion: nil)
        }
        updateCategoryButtonTitle()
    }
}
