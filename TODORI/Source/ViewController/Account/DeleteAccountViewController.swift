//
//  DeleteAccountViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/16.
//

import UIKit

class DeleteAccountViewController: UIViewController {
    private let titleLabel1: UILabel = LabelManager.shared.getEditTitleLabel(text: "계정 정보")
    private let accountInfo: UIView = ViewManager.shared.getAccountInfo()
    private let profileImageView: UIImageView = ImageViewManager.shared.getProileImageView()
    private let nickNameLabel: UILabel = LabelManager.shared.getNickNameLabel()
    private let emailLabel: UILabel = LabelManager.shared.getEmailLabel()
    private let titleLabel2: UIStackView = StackViewManager.shared.getAccountTitleLabel(text: "탈퇴 전 안내드려요", color: UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1), filename: "delete-icon", resize: 16, spacing: 3)
    private let messageLabel: UILabel = LabelManager.shared.getMessageLabel(text: "계정 탈퇴 시 모든 정보와 데이터가 삭제됩니다.\n복구 및 백업이 불가능하오니, 신중히 생각해 주세요.", weight: .regular, color: .black)
    private let checkLabelButton: UIButton = ButtonManager.shared.getCheckLabelButton()
    private let deleteAccountButton: UIButton = ButtonManager.shared.getFinishButton(title: "계정 탈퇴하기", titleColor: UIColor(red: 0.554, green: 0.554, blue: 0.554, alpha: 1), false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
                
        setupButton()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let cornerRadius = min(self.profileImageView.bounds.width, self.profileImageView.bounds.height) / 2
        self.profileImageView.layer.cornerRadius = cornerRadius
    }

    private func setupButton() {
        checkLabelButton.addTarget(self, action: #selector(checkLabelTapped), for: .touchUpInside)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        DispatchQueue.main.async {
            if let imageData = UserDefaults.standard.data(forKey: "image") {
                self.profileImageView.image = UIImage(data: imageData)
            } else {
                self.profileImageView.image = UIImage(named: "default-profile")
            }
        }
        
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction:  #selector(backButtonTapped), title: "계정 탈퇴", showSeparator: false)
        
        view.addSubview(titleLabel1)
        view.addSubview(accountInfo)
        accountInfo.addSubview(profileImageView)
        accountInfo.addSubview(nickNameLabel)
        accountInfo.addSubview(emailLabel)
        view.addSubview(titleLabel2)
        view.addSubview(messageLabel)
        view.addSubview(checkLabelButton)
        view.addSubview(deleteAccountButton)
        
        titleLabel1.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(32)
            make.leading.equalToSuperview().offset(34)
        }
        
        accountInfo.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(34)
            make.centerX.equalToSuperview()
            make.height.equalTo(63)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(accountInfo.snp.leading).offset(15)
            make.width.equalTo(41)
            make.height.equalTo(41)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(accountInfo.snp.top).offset(15)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }

        emailLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.bottom.equalTo(accountInfo.snp.bottom).offset(-15)
        }
        
        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(accountInfo.snp.bottom).offset(22)
            make.leading.equalToSuperview().offset(34)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(34)
        }
        
        checkLabelButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(41.5)
            make.leading.equalToSuperview().offset(34)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(checkLabelButton.snp.bottom).offset(41.5)
            make.leading.equalToSuperview().offset(34)
            make.trailing.equalToSuperview().offset(-34)
            make.height.equalTo(50)
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func checkLabelTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.deleteAccountButton.backgroundColor = UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
            self.deleteAccountButton.setTitleColor(.black, for: .normal)
            self.deleteAccountButton.isEnabled = true
        } else {
            self.deleteAccountButton.setTitleColor(UIColor(red: 0.554, green: 0.554, blue: 0.554, alpha: 1), for: .normal)
            self.deleteAccountButton.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
            self.deleteAccountButton.isEnabled = false
        }
    }
    
    @objc func deleteAccountButtonTapped() {
        let dimmingView = UIView(frame: UIScreen.main.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.alpha = 0
        self.view.addSubview(dimmingView)
        let popupView = TwoButtonPopupView(title: "정말 떠나시나요?😢", message: "다음에 또 만나길 기대할게요.", buttonText1: "취소", buttonText2: "확인", dimmingView: dimmingView)
        popupView.delegate = self
        popupView.alpha = 0
        self.view.addSubview(popupView)
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(264)
            make.height.equalTo(167)
        }
        UIView.animate(withDuration: 0.2) {
            popupView.alpha = 1
            dimmingView.alpha = 1
        }
    }
    
    func deleteAccount() {
        UserService.shared.deleteAccount() { result in
            switch result {
            case .success(let response):
                if response.resultCode == 200 {
                    print("이백")
                    SceneDelegate.reset()
                } else if response.resultCode == 500 {
                    print("오백")
                }
            case .failure:
                print("failure")
            }
        }
    }
}

extension DeleteAccountViewController: TwoButtonPopupViewDelegate {
    func buttonTappedDelegate() {
        deleteAccount()
    }    
}

extension DeleteAccountViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

extension DeleteAccountViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
