//
//  LogoutPopupView.swift
//  TODORI
//
//  Created by Dasol on 2023/05/22.
//

import UIKit

class TwoButtonPopupView: UIView {
    weak var delegate: TwoButtonPopupViewDelegate?
    
    var titleLabel: UILabel!
    var messageLabel: UILabel!
    var actionButton1: UIButton!
    var actionButton2: UIButton!
    var dimmingView: UIView!
    
    init(title: String, message: String, buttonText1: String, buttonText2: String,  dimmingView: UIView) {
        super.init(frame: UIScreen.main.bounds)
        setupUI()
        
        titleLabel.text = title
        messageLabel.text = message
        actionButton1.setTitle(buttonText1, for: .normal)
        actionButton2.setTitle(buttonText2, for: .normal)
        self.dimmingView = dimmingView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.masksToBounds = true // 나가면 짤림
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(37)
            $0.width.equalToSuperview()
        }
        
        messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(11)
            $0.width.equalToSuperview()
        }
        
        actionButton1 = UIButton(type: .system)
        actionButton1.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        actionButton1.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        actionButton1.setTitleColor(UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1), for: .normal)
        actionButton1.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        addSubview(actionButton1)
        actionButton1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(167 - 45)
            $0.bottom.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.width.equalTo(132)
            $0.height.equalTo(45)
        }
        
        actionButton2 = UIButton(type: .system)
        actionButton2.backgroundColor = UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
        actionButton2.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        actionButton2.setTitleColor(UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1), for: .normal)
        actionButton2.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        
        addSubview(actionButton2)
        actionButton2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(167 - 45)
            $0.bottom.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(132)
            $0.width.equalTo(132)
            $0.height.equalTo(45)
        }
    }
    
    @objc func closeButtonTapped() {
        self.dimmingView.isHidden = true
        self.removeFromSuperview()
    }

    @objc func okButtonTapped() {
            delegate?.buttonTappedDelegate()
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0 // 투명하게(디졸브)
                self.dimmingView.alpha = 0
            }) { (_) in
                self.removeFromSuperview()
                self.dimmingView.removeFromSuperview()
            }
        }
}

protocol TwoButtonPopupViewDelegate: AnyObject {
    func buttonTappedDelegate()
}
