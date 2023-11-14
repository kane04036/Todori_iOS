//
//  ButtonManager.swift
//  TODORI
//
//  Created by Dasol on 2023/06/05.
//

import UIKit

class ButtonManager {
    static let shared = ButtonManager()
    
    private init() {}
    
    func getNextButton(isEnabled: Bool) -> UIButton {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "next-button")?.resize(to: CGSize(width: UIScreen.main.bounds.width * 0.16, height: UIScreen.main.bounds.width * 0.16))
        button.setImage(image, for: .normal)
        button.isEnabled = isEnabled
        return button
    }
    
    func getAutoLogInButton() -> UIButton {
        let button = UIButton()
        button.setTitle(" 자동 로그인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setImage(UIImage(named: "tick-circle")?.resize(to: CGSize(width: 17, height: 17)), for: .normal)
        button.setImage(UIImage(named: "tick-circle2")?.resize(to: CGSize(width: 17, height: 17)), for: .selected)
        return button
    }
    
    func getLoginButton() -> UIButton {
        let button = UIButton()
        button.applyColorAnimation()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = UIColor.mainColor
        button.layer.cornerRadius = 18
        return button
    }
    
    func getFindPasswordButton() -> UIButton {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return button
    }
    
    func getSignUpButton() -> UIButton {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return button
    }
    
    func getEditProfileButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "edit-profile")?.resize(to: CGSize(width: 24, height: 24)), for: .normal)
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        button.configuration = configuration
        return button
    }
    
    func getMyPageSettingButton(title: String, image: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        let image = UIImage(named: image)?.resize(to: CGSize(width: 18, height: 18))
        button.setImage(image, for: .normal)
        return button
    }
    
    func getSettingGroupButton() -> UIButton {
        let button = UIButton()
        let image = UIImage(named: "edit-groups")?.resize(to: CGSize(width: 7, height: 14))
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        button.contentHorizontalAlignment = .right
        button.contentVerticalAlignment = .top
        return button
    }
    
    func getLogoutButton() -> UIButton {
        let button = UIButton()
        button.setTitle(" 로그아웃", for: .normal)
        button.setTitleColor(UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        let image = UIImage(named: "logout")?.resize(to: CGSize(width: 18, height: 18))
        button.setImage(image, for: .normal)
        return button
    }
    
    func getEditProfileImageButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "edit-profile-image")?.resize(to: CGSize(width: 26, height: 26)), for: .normal)
        return button
    }
    
    func getChangePasswordButton() -> UIButton {
        let button = UIButton()
        button.applyColorAnimation()
        button.setTitle("비밀번호 변경", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1).cgColor
        button.layer.cornerRadius = 8
        return button
    }

    func getDeleteAccountButton() -> UIButton {
        let button = UIButton()
        button.setTitle("계정 탈퇴하기", for: .normal)
        button.setTitleColor( UIColor(red: 0.554, green: 0.554, blue: 0.554, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }
    
    func getFinishButton(title: String, titleColor: UIColor = .black, _ isEnabled: Bool = true) -> UIButton {
        let button = UIButton()
        button.applyColorAnimation()
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        button.layer.cornerRadius = 8
        button.isEnabled = isEnabled
        return button
    }
    
    func getCheckLabelButton() -> UIButton {
        let button = UIButton()
        button.setTitle("  안내사항을 모두 확인하였으며, 탈퇴를 진행합니다.", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .light)
        button.setTitleColor(UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1), for: .normal)
        button.setImage(UIImage(named: "checkbox-off")?.resize(to: CGSize(width: 16, height: 16)), for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.setImage(UIImage(named: "checkbox-on")?.resize(to: CGSize(width: 16, height: 16)), for: .selected)
        return button
    }
    
    func getFriendManagementBlackButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return button
    }
    
    func getFriendManagementGrayButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return button
    }
    
    func getAddFriendButton() -> UIButton {
        let button = UIButton()
        button.setTitle("친구 추가하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1).cgColor
        button.layer.cornerRadius = 7
        return button
    }
    
    func getManagementButton(title: String) -> UIButton{
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor(red: 0.867, green: 0.859, blue: 0.859, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.textAlignment = .center
        return button
    }
    
    func getAcceptButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 1, green: 0.85, blue: 0.73, alpha: 1)
        button.setTitle("수락", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return button
    }
    
    func getRejectButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        button.setTitle("거절", for: .normal)
        button.setTitleColor(UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return button
    }
    
    func getFavoriteButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "star-off"), for: .normal)
        return button
    }
    
    func getDeleteFriendButton() -> UIButton {
        let button = UIButton()
        button.setTitle("친구 끊기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.87, green: 0.86, blue: 0.86, alpha: 1).cgColor
        return button
    }
}
