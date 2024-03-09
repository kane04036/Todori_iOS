//
//  FriendTodoTableViewCell.swift
//  TODORI
//
//  Created by 제이콥 on 3/8/24.
//

import UIKit

class FriendTodoTableViewCell: UITableViewCell {
    var checkbox: UIImageView = UIImageView()
    var titleTextField: UITextField = UITextField()
    var cellBackgroundView: UIView = UIView()
    var todo: ToDo = .init(year: "", month: "", day: "", title: "", done: false, isNew: false, writer: "", color: 0, id: 0, time: "0000", description: "")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "TodoCell")
        titleTextField.isEnabled = false
        self.checkbox.image = todo.done ? Color.shared.getCheckBoxImage(colorNum: todo.color) : UIImage(named: "checkbox")
        self.titleTextField.text = todo.title
        
        self.addComponent()
        self.setAutoLayout()
        self.setAppearence()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //view에 컴포넌트 추가
    private func addComponent(){
        cellBackgroundView.addSubview(titleTextField)
        cellBackgroundView.addSubview(checkbox)
        self.contentView.addSubview(cellBackgroundView)

    }
    
    //오토 레이아웃 적용
    private func setAutoLayout(){
        cellBackgroundView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.centerY.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().inset(4)
        }
        checkbox.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }

        titleTextField.snp.makeConstraints { make in
            make.left.equalTo(checkbox.snp.right).offset(7)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    //컴포넌트 외형 설정
    private func setAppearence(){
        cellBackgroundView.backgroundColor = UIColor.defaultColor
        cellBackgroundView.layer.cornerRadius = 10
        cellBackgroundView.clipsToBounds = true
        self.backgroundColor = .clear
        
        titleTextField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleTextField.textColor = UIColor.textColor
        checkbox.image = UIImage(named: "checkbox")
        
    }

}
