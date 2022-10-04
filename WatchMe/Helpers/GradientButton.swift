//
//  GradientButton.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import UIKit

class GradientButton: UIButton {

    let gradient = CAGradientLayer()
    
    init(colors: [CGColor]) {
        super.init(frame: .zero)
        gradient.frame = bounds
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.insertSublayer(gradient, below: imageView?.layer)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
        tranformSize()
    }
    
    private func tranformSize() {
        UIView.animate(withDuration: 0.25) {
            self.transform = self.isTouchInside ? CGAffineTransform(scaleX: 0.95, y: 0.95) : CGAffineTransform.identity
        }
    }
}
