//
//  UIView+Modifications.swift
//  Drink & Talk
//
//  Created by Nikola Barbarić on 21.09.2021..
//

import UIKit

extension UIView {
    func makeRounded(withCornerRadius radius: Double) {
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
    
    func makeRoundedTopCorners(withCornerRadius radius: Double){
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func shake() {
        self.transform = CGAffineTransform(translationX: -2, y: 0)
        UIView.animate(withDuration: 0.2, delay: 0, options: [.autoreverse]) {
            UIView.setAnimationRepeatCount(3)
            self.transform = .identity
        }
    }
}
