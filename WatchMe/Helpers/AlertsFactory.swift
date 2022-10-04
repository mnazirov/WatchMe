//
//  AlertsFactory.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import UIKit

protocol AlertFactory {
    func getAlert(with title: String, and message: String) -> UIViewController
}

class DefaultsAlertFactory: AlertFactory {
    
    func getAlert(with title: String, and message: String) -> UIViewController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action =  UIAlertAction(title: "Закрыть", style: .default)
        alert.addAction(action)
        return alert
    }
    
}
