//
//  EditProfileViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/15.
//

import UIKit
import PhotosUI

class EditProfileViewController: UIViewController {
    private let profileImageView: UIImageView = ImageViewManager.shared.getProileImageView()
    private let editProfileImageButton: UIButton = ButtonManager.shared.getEditProfileImageButton()
    private let nickNameTitleLabel: UILabel = LabelManager.shared.getEditTitleLabel(text: "닉네임")
    private let nickNameTextField: UITextField = TextFieldManager.shared.getNicknameTextField()
    private let emailTitleLabel: UILabel = LabelManager.shared.getEditTitleLabel(text: "이메일")
    private let emailLabel: UILabel = LabelManager.shared.getEditProfileEmailLabel()
    private let changePasswordButton: UIButton = ButtonManager.shared.getChangePasswordButton()
    private let deleteAccountButton: UIButton = ButtonManager.shared.getDeleteAccountButton()
    private let indicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    
        setupDelegate()
        setupButton()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserSession.shared.image = nil
        UserSession.shared.isChangedImage = false
        
        DispatchQueue.main.async {
            if let imageData = UserDefaults.standard.data(forKey: "image") {
                self.profileImageView.image = UIImage(data: imageData)
            } else {
                self.profileImageView.image = UIImage(named: "default-profile")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            nickNameTextField.text = nickname
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let cornerRadius = min(self.profileImageView.bounds.width, self.profileImageView.bounds.height) / 2
        self.profileImageView.layer.cornerRadius = cornerRadius
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    private func setupDelegate() {
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        nickNameTextField.delegate = self

    }
    
    private func setupButton() {
        editProfileImageButton.addTarget(self, action: #selector(editProfileImageButtonTapped), for: .touchUpInside)
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction:  #selector(backButtonTapped), title: "프로필 수정", showSeparator: false)
        navigationItem.rightBarButtonItem = NavigationBarManager.shared.getCompleteBarButtonItem(target: self, selector: #selector(completeButtonTapped))
        
        view.addSubview(profileImageView)
        view.addSubview(editProfileImageButton)
        view.addSubview(nickNameTitleLabel)
        view.addSubview(nickNameTextField)
        view.addSubview(emailTitleLabel)
        view.addSubview(emailLabel)
        view.addSubview(changePasswordButton)
        view.addSubview(deleteAccountButton)
        view.addSubview(indicatorView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(26)
            make.centerX.equalToSuperview()
            make.width.equalTo(89)
            make.height.equalTo(89)
        }
        
        editProfileImageButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(92.83)
            make.leading.equalTo(profileImageView.snp.leading).offset(62)
        }
      
        nickNameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(26)
            make.leading.equalToSuperview().offset(20)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameTitleLabel.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(45)
        }
        
        emailTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(20)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(45)
        }
        
        changePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-35)
            make.centerX.equalToSuperview()
            make.width.equalTo(93)
            make.height.equalTo(30)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButtonTapped() {
        guard let enteredNickname = nickNameTextField.text,
              let nickname = UserDefaults.standard.string(forKey: "nickname"),
              let isChanged = UserSession.shared.isChangedImage
        else {
            print("가드 오류")
            return
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = .black
        editProfileImageButton.isUserInteractionEnabled = false
        changePasswordButton.isEnabled = false
        deleteAccountButton.isEnabled = false
        indicatorView.startAnimating()
        
        if isChanged {
            if let imageData = UserSession.shared.image {
                if let image = UIImage(data: imageData) {
                    if enteredNickname == "" {
                        self.editProfile(image: image, nickname: nickname, imdel: false)
                    } else {
                        self.editProfile(image: image, nickname: enteredNickname, imdel: false)
                    }
                }
            } else {
                if enteredNickname == "" {
                    self.editProfile(image: nil, nickname: nickname, imdel: true)
                } else {
                    self.editProfile(image: nil, nickname: enteredNickname, imdel: true)
                }
            }
        } else {
            if enteredNickname == "" {
                self.editProfile(image: nil, nickname: nickname, imdel: false)
            } else {
                self.editProfile(image: nil, nickname: enteredNickname, imdel: false)
            }
        }
    }

    @objc func editProfileImageButtonTapped() {
        let albumAction = UIAlertAction(title: "앨범에서 선택", style: .default) { [weak self] _ in
            var configurcation = PHPickerConfiguration()
            configurcation.selectionLimit = 1
            
            let picker = PHPickerViewController(configuration: configurcation)
            picker.delegate = self
            
            self?.present(picker, animated: true, completion: nil)
        }
        
        let defaultImageAction = UIAlertAction(title: "기본 이미지로 설정", style: .default) { _ in
            let image = UIImage(named: "default-profile")
            if let imageData = image?.pngData() {
                self.profileImageView.image = UIImage(data: imageData)
                UserSession.shared.image = nil
                UserSession.shared.isChangedImage = true
            }
        }
        
        let cancelAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(albumAction)
        alertController.addAction(defaultImageAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func changePasswordButtonTapped() {
        let nextVC = ChangePasswordViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func deleteAccountButtonTapped() {
        navigationController?.pushViewController(DeleteAccountViewController(), animated: true)
    }
    
    func editProfile(image: UIImage?, nickname: String, imdel: Bool) {
        UserService.shared.editProfile(image: image, nickname: nickname, imdel: imdel) { result in
            switch result {
            case .success(let response):
                self.indicatorView.stopAnimating()
                self.editProfileImageButton.isUserInteractionEnabled = true
                self.changePasswordButton.isEnabled = true
                self.deleteAccountButton.isEnabled = true

                if response.resultCode == 200 {
                    print("이백")
                    guard let responseData = response.data else { return }
                    
                    UserDefaults.standard.set(responseData.nickname, forKey: "nickname")
                
                    if let image = responseData.image {
                        let imageData = UserSession.shared.base64StringToImage(base64String: image)?.pngData()
                        UserDefaults.standard.set(imageData, forKey: "image")
                    } else {
                        UserDefaults.standard.set(nil, forKey: "image")
                    }
                    let dimmingView = UIView(frame: UIScreen.main.bounds)
                    dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    dimmingView.alpha = 0
                    self.view.addSubview(dimmingView)
                    let popupView = OneButtonPopupView(title: "프로필 수정", message: "프로필 수정이 완료되었습니다.", buttonText: "확인", buttonColor: UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1), dimmingView: dimmingView)
                    popupView.delegate = self
                    popupView.alpha = 0
                    self.view.addSubview(popupView)
                    popupView.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                        make.width.equalTo(264)
                        make.height.equalTo(167)
                    }
                    UIView.animate(withDuration: 0.3) {
                        popupView.alpha = 1
                        dimmingView.alpha = 1
                    }
                } else if response.resultCode == 500 {
                    print("오백")
                }
            case .failure(let err):
                print("failure: \(err)")
            }
        }
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .light),
            .foregroundColor: UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1)
        ]
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            let attributedPlaceholder = NSAttributedString(string: nickname, attributes: attributes)
            textField.attributedPlaceholder = attributedPlaceholder
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .light),
            .foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        ]
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            let attributedPlaceholder = NSAttributedString(string: nickname, attributes: attributes)
            textField.attributedPlaceholder = attributedPlaceholder
        }
    }
}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let itemProvider = results.first?.itemProvider else {
            // 선택된 항목이 없을 경우 
            return
        }
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        var fixedImage: UIImage?
                        if image.imageOrientation != .up {
                            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
                            image.draw(in: CGRect(origin: .zero, size: image.size))
                            fixedImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                        } else {
                            fixedImage = image
                        }
                        if let imageData = fixedImage?.pngData() {
                            self.profileImageView.image = UIImage(data: imageData)
                            UserSession.shared.image = imageData
                            UserSession.shared.isChangedImage = true
                        }
                    }
                }
            }
        }
    }
}

extension EditProfileViewController: OneButtonPopupViewDelegate {
    func buttonTappedDelegate() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension EditProfileViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

extension EditProfileViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
