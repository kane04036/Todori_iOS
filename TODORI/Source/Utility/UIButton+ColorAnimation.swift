//
//  UIButton+ColorAnimation.swift
//  TODORI
//
//  Created by Dasol on 2023/05/23.
//

import UIKit

extension UIButton {
    func applyColorAnimation() {
        addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(buttonTouchUpOutside), for: .touchUpOutside)
    }

    @objc private func buttonTouchDown() {
        animateButtonColorChange(isButtonPressed: true)
    }

    @objc private func buttonTouchUpInside() {
        animateButtonColorChange(isButtonPressed: false)
    }

    @objc private func buttonTouchUpOutside() {
        animateButtonColorChange(isButtonPressed: false)
    }

    private func animateButtonColorChange(isButtonPressed: Bool) {
        UIView.animate(withDuration: 0.3) {
            if isButtonPressed {
                self.alpha = 0.5
            } else {
                self.alpha = 1
            }
        }
    }
}


