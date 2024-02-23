//
//  DeleteFriendPopupViewController.swift
//  TODORI
//
//  Created by 제이콥 on 1/19/24.
//

import UIKit
import SnapKit

class DeleteFriendPopupViewController: UIViewController {
    var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        label.textColor = .black
        label.text = "친구 끊기"
        return label
    }()
    
    var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .black
        label.text = "정말 친구를 끊으시나요?"
        return label
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        return button
    }()
    
    var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 0.85, blue: 0.73, alpha: 1)
        return button
    }()
    
    var popupBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in popup view did load")
        setUI()
    }
    
    func setUI(){
        popupBackground.addSubViews([mainTitleLabel, subTitleLabel, cancelButton, confirmButton ])
        view.addSubview(popupBackground)
        
        popupBackground.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(63)
            make.right.equalToSuperview().offset(-63)
            make.centerY.equalToSuperview()
            make.height.equalTo(167)
        }
        
        mainTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(37)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(11)
            make.centerX.equalToSuperview()

        }
        
    }
    
}
