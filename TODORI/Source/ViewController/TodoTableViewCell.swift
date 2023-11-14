//
//  TodoCell.swift
//  TODORI
//
//  Created by 제임스 on 2023/04/29.
//

import UIKit
import SnapKit

class TodoTableViewCell:UITableViewCell{
    var checkbox:UIButton = UIButton()
    var titleTextField:UITextField = UITextField()
    var cellBackgroundView:UIView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "TodoCell")
        
        self.addComponent()
        self.setAutoLayout()
        self.setAppearence()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponent(){
//        cellBackgroundView.addSubview(titleTextField)
//        cellBackgroundView.addSubview(checkbox)
        self.contentView.addSubview(cellBackgroundView)

    }
    
    private func setAutoLayout(){
        cellBackgroundView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.centerY.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(3)
            make.bottom.equalToSuperview().inset(3)
        }
//        checkbox.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(13)
//            make.centerY.equalToSuperview()
//        }
//        titleTextField.snp.makeConstraints { make in
//            make.left.equalTo(checkbox.snp.right).offset(7)
//            make.centerY.equalToSuperview()
//        }
       
    }
    private func setAppearence(){
        cellBackgroundView.backgroundColor = .white
        cellBackgroundView.layer.cornerRadius = 10
        cellBackgroundView.clipsToBounds = true
        self.backgroundColor = .clear
        
        //debug
        titleTextField.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleTextField.backgroundColor = .gray
        checkbox.setImage(UIImage(named: "checkbox"), for: .normal)
    }
}

