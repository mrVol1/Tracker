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

final class AddCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateCategoryViewControllerDelegate {
    
    weak var delegate: AddCategoryViewControllerDelegate? {
        didSet {
        }
    }
    
    let customFontBold = UIFont(name: "SFProDisplay-Medium", size: UIFont.labelFontSize)
    let defaultImageView = UIImageView(image: UIImage(named: "1"))
    let textImage = UILabel()
    
    var textImageBottomAnchor: NSLayoutYAxisAnchor?
    var buttonTopAnchor: NSLayoutConstraint?
    var tableViewHeightAnchor: NSLayoutConstraint?
    var categoriesList: [TrackerCategory] = []
    var selectedIndexPath: IndexPath?
    
    private var isCheckmarkSelected: Bool = false
    private var createdCategoryName: TrackerCategory?
    private var isCellSelected: Bool = false
    private let label = UILabel()
    private let tableView = UITableView()
    private let categoryButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        if categoriesList.isEmpty {
            defaultScreen()
        } else {
            tableScreen()
        }
        
        creatLabel()
        constraitsForLabel(label)
        setupButtonCreated()
        constraitsForSetupButton()
    }
    
    // MARK: - Screen Config
    
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
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tableView.clipsToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
    
    fileprivate func creatLabel() {
        label.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)).withSize(16)
        label.textColor = .black
        label.text = "Категория"
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
        cell.categoryLabel.text = categoriesList[indexPath.row].label
        cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        
        if indexPath == selectedIndexPath {
            cell.checkmarkImageView.isHidden = false
        } else {
            cell.checkmarkImageView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if selectedIndexPath == indexPath {
            if let cell = tableView.cellForRow(at: indexPath) as? CategoryCellTableViewCell {
                cell.checkmarkImageView.isHidden.toggle()
                isCheckmarkSelected = !cell.checkmarkImageView.isHidden
                updateCategoryButtonTitle()
            }
        } else {
            if let cell = tableView.cellForRow(at: indexPath) as? CategoryCellTableViewCell {
                selectedIndexPath = indexPath
                isCheckmarkSelected = cell.checkmarkImageView.isHidden
                updateCategoryButtonTitle()
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Screen Func
    
    func didCreatedCategory(_ createdCategory: TrackerCategory) {
        categoriesList.append(createdCategory)
        delegate?.didSelectCategory(createdCategory)
        tableView.reloadData()
    }
    
    func defaultScreen() {
        self.defaultImage()
        self.defaultText()
        self.constraitsForDefaultText()
    }
    
    func tableScreen() {
        self.createdTableForCategoriesList()
        self.constraitsForTableForCategoriesList(label)
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
            delegate?.didSelectCategory(createdCategoryName!)
            navigateToNewHabitCreateController(selectedCategory: createdCategoryName!)
        } else {
            let createCategoryButton = CreateCategoryViewController(delegate: self)
            createCategoryButton.onDismiss = { [weak self] in
                self?.viewDidLoad()
            }
            let createCategoryNavigationController = UINavigationController(rootViewController: createCategoryButton)
            createCategoryButton.delegate = self
            present(createCategoryNavigationController, animated: true, completion: nil)
        }
        updateCategoryButtonTitle()
    }
}
