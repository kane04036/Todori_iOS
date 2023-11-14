//
//  ImageViewMangager.swift
//  TODORI
//
//  Created by Dasol on 2023/06/22.
//

import UIKit

class ImageViewManager {
    static let shared = ImageViewManager()
    
    func getUIImageViewScaleToFit(fileName: String) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: fileName))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func getProileImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    func getColorView(_ filename: String) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: filename)?.resize(to: CGSize(width: 25, height: 25)))
        return imageView
    }
    
    func getRequestProfileImageView() -> UIImageView{
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
}
