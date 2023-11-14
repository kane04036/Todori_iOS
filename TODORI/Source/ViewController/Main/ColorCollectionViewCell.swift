//
//  ColorCollectionViewCell.swift
//  TODORI
//
//  Created by Dasol on 2023/05/29.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    var view: UIView = UIView()
        
        override init(frame: CGRect) {
            super.init(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            //원형 뷰의 외형 설정
            view.backgroundColor = .lightGray
            view.clipsToBounds = true
            view.layer.cornerRadius = view.fs_width/2
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
