//
//  NewHabitController.swift
//  Tracker
//
//  Created by Eduard Karimov on 26/11/2023.
//

import UIKit

final class NewHabitController: UIViewController {    
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        //создание лейбла
        let label = UILabel()
        
        let customFontBold = UIFont(name: "SFProDisplay-Medium", size: UIFont.labelFontSize)
        label.font = UIFontMetrics.default.scaledFont(for: customFontBold ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)).withSize(16)
        label.textColor = .black
        label.text = "Создание трекера"
        view.addSubview(label)
        
        //создание констрейтов для лейбла
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        //создание кнопки "Привычка"
        
    }
}
