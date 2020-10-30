//
//  GradientButton.swift
//  AcmeTrading
//
//  Created by John Wilson on 28/10/2020.
//  Help from https://stackoverflow.com/questions/37903124/set-background-gradient-on-button-in-swift

import UIKit
class GradientButton: UIButton {

    var gradientColors: [CGColor]?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        if let colors = gradientColors {
            l.frame = self.bounds
            l.colors = colors
            l.startPoint = CGPoint(x: 0, y: 0.5)
            l.endPoint = CGPoint(x: 1, y: 0.5)
//            l.cornerRadius = 16
            layer.insertSublayer(l, at: 0)
        }
        return l
    }()
}
