//
//  Extensions.swift
//  TODORI
//
//  Created by Dasol on 2023/05/17.
//

import UIKit

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIColor {
    static var mainColor: UIColor {
        return UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
    }
}
