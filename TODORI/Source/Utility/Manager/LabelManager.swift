//
//  LabelManager.swift
//  TODORI
//
//  Created by Dasol on 2023/06/21.
//

import UIKit

class LabelManager {
    static let shared = LabelManager()
    
    private init() {}
    
    func createSignUpNumberLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        return label
    }
    
    static func createSignUpTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return label
    }
    
    static func createSignUpSubtitleLabel(text: String, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = textColor
        return label
    }
    
    func getErrorLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        label.isHidden = true
        return label
    }
    
    func createCodeLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true

        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 41).isActive = true
        label.heightAnchor.constraint(equalToConstant: 53).isActive = true
        return label
    }

    func getEmailBoxLabel() -> UILabel {
        let label = UILabel()
        if let email = UserSession.shared.signUpEmail {
            label.text = "   " + email
        }
        label.textAlignment = .left
        label.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }
    
    func getNickNameLabel() -> UILabel {
        let label = UILabel()
        label.text = UserDefaults.standard.string(forKey: "nickname")
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }

    func getEmailLabel() -> UILabel {
        let label = UILabel()
        label.text = UserDefaults.standard.string(forKey: "email")
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        return label
    }
    
    func getEditTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }

    func getEditProfileEmailLabel() -> UILabel {
        let label = UILabel()
        label.text = "   " + (UserDefaults.standard.string(forKey: "email") ?? "(UNKNOWN)")
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textColor = UIColor(red: 0.617, green: 0.617, blue: 0.617, alpha: 1)
        label.backgroundColor = UIColor(red: 0.946, green: 0.946, blue: 0.946, alpha: 1)
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1).cgColor
        label.clipsToBounds = true
        return label
    }
    
    func getMessageLabel(text: String, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: weight)
        label.textColor = color
        
        let underlineView = UIView()
        underlineView.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        label.addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(label.snp.bottom).offset(27)
            make.leading.equalTo(label.snp.leading)
            make.trailing.equalTo(label.snp.trailing)
        }
        return label
    }
    
    func getAddEmailLabel() -> UILabel {
        let label = UILabel()
        label.text = "이메일"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        return label
    }
    
    func getFriendNicknameLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        return label
    }
    
    func getFriendEmailLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        return label
    }
    
}

class StackViewManager {
    static let shared = StackViewManager()
    
    func getHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }
    
    func getAccountTitleLabel(text: String, color: UIColor, filename: String, resize: CGFloat, spacing: CGFloat) -> UIStackView {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = color
        let imageView = UIImageView(image: UIImage(named: filename))
        imageView.snp.makeConstraints { make in
            make.width.equalTo(resize)
            make.height.equalTo(resize)
        }
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.spacing = spacing
        return stackView
    }
    

}
