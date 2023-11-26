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
        let habbitButton = UIButton()
        habbitButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        habbitButton.setTitle("Привычка", for: .normal)
        habbitButton.setTitleColor(.white, for: .normal)
        habbitButton.layer.cornerRadius = 16
        habbitButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        habbitButton.backgroundColor = .black
        view.addSubview(habbitButton)
        
        //констрейты кнопки
        habbitButton.translatesAutoresizingMaskIntoConstraints = false
        
        habbitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

        NSLayoutConstraint.activate([
            habbitButton.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 300),
            habbitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habbitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            habbitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
        
        //создание кнопки "Нерегулярные события"
        let iventButton = UIButton()
        iventButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        iventButton.setTitle("Нерегулярные события", for: .normal)
        iventButton.setTitleColor(.white, for: .normal)
        iventButton.layer.cornerRadius = 16
        iventButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        iventButton.backgroundColor = .black
        view.addSubview(iventButton)
        
        //констрейты кнопки
        iventButton.translatesAutoresizingMaskIntoConstraints = false
        
        iventButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

        NSLayoutConstraint.activate([
            iventButton.bottomAnchor.constraint(equalTo: habbitButton.bottomAnchor, constant: 78),
            iventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iventButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            iventButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
}
