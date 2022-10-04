//
//  View+Extensions.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import UIKit

extension UIView {
    func embed(view: UIView) {
        self.addSubview(view)
        constraintsEmbed(view: view)
    }
    
    private func constraintsEmbed(view: UIView) {
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            view.widthAnchor.constraint(equalTo:   self.widthAnchor),
            view.heightAnchor.constraint(equalTo:  self.heightAnchor)
        ])
    }
    
    func addInCenter(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func addLine(color: UIColor, height: CGFloat) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: height),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomAnchor.constraint(equalTo: lineView.bottomAnchor),
            trailingAnchor.constraint(equalTo: lineView.trailingAnchor),
        ])
    }
    
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
}
