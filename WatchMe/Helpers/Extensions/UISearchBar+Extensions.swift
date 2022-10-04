//
//  UISearchBar+Extensions.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import UIKit

extension UISearchBar {
    func addLine() {
        let viewLine = UIView()
        viewLine.translatesAutoresizingMaskIntoConstraints = false
        viewLine.backgroundColor = .systemGray3
        
        let widthConstant: CGFloat = 1
        let insets = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 35)
        
        searchTextField.addSubview(viewLine)
        NSLayoutConstraint.activate([
            viewLine.widthAnchor.constraint(equalToConstant: widthConstant),
            viewLine.topAnchor.constraint(equalTo: searchTextField.topAnchor, constant: insets.top),
            viewLine.rightAnchor.constraint(equalTo: searchTextField.rightAnchor, constant: -insets.right)
        ])
        
        let bottomConstraint = viewLine.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor,
                                                                constant: -insets.bottom)
        bottomConstraint.priority = .defaultHigh
        bottomConstraint.isActive = true
    }
}
