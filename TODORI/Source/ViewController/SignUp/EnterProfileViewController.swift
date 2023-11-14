//
//  EnterProfileViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/02.
//

import UIKit

class EnterProfileViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    private let contentView = UIView()
    private var stackView = UIStackView()
    private let numberLabel: UILabel = LabelManager.shared.createSignUpNumberLabel(text: "3/3")
    private let titleLabel: UILabel = LabelManager.createSignUpTitleLabel(text: "프로필을\n설정해 주세요")
    private let emailLabel: UILabel = LabelManager.createSignUpSubtitleLabel(text: "이메일", textColor: UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1))
    private let emailBoxLabel: UILabel = LabelManager.shared.getEmailBoxLabel()
    private let nickNameLabel: UILabel = LabelManager.createSignUpSubtitleLabel(text: "닉네임", textColor: UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1))
    private let nickNameTextField: UITextField = TextFieldManager.shared.getSignUpProfileTextField(tag: 1, text: "2~6자 이하로 입력해 주세요")
    private let nickNameGenerationErrorLabel: UILabel = LabelManager.shared.getErrorLabel(text: "닉네임 생성 규칙에 맞지 않습니다.")
    private let passwordLabel: UILabel = LabelManager.createSignUpSubtitleLabel(text: "비밀번호", textColor: UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1))
    private let passwordTextField: UITextField = TextFieldManager.shared.getSignUpProfileTextField(tag: 2, text: "8~15자 이내의 영문자, 숫자, 특수문자를 포함해 주세요", isSecureTextEntry: true)
    private let passwordGenerationErrorLabel: UILabel = LabelManager.shared.getErrorLabel(text: "비밀번호 생성 규칙에 맞지 않습니다.")
    private let checkPasswordLabel: UILabel = LabelManager.createSignUpSubtitleLabel(text: "비밀번호 확인", textColor: UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1))
    private let checkPasswordTextField: UITextField = TextFieldManager.shared.getSignUpProfileTextField(tag: 3, text: "8~15자 이내의 영문자, 숫자, 특수문자를 포함해 주세요", isSecureTextEntry: true)
    private let passwordInconsistencyErrorLabel: UILabel = LabelManager.shared.getErrorLabel(text: "비밀번호가 일치하지 않습니다.")
    private let nextButton: UIButton = ButtonManager.shared.getNextButton(isEnabled: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupDelegate()
        setupTapGesture()
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        setupUI()
                
        registerKeyboardNotifications()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    private func setupDelegate() {
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        scrollView.delegate = self
        nickNameTextField.delegate = self
        passwordTextField.delegate = self
        checkPasswordTextField.delegate = self
    }
    
    private func setupUI() {
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction: #selector(backButtonTapped), title: "", showSeparator: false)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .white
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let topSafeAreaHeight = windowScene.windows.first?.safeAreaInsets.top,
               let navigationBarHeight = navigationController?.navigationBar.frame.height {
                let totalHeight = topSafeAreaHeight + navigationBarHeight
                make.height.equalTo(UIScreen.main.bounds.height - totalHeight)
            }
        }
        
        stackView = UIStackView(arrangedSubviews: [nickNameLabel, nickNameTextField, nickNameGenerationErrorLabel, passwordLabel, passwordTextField, passwordGenerationErrorLabel, checkPasswordLabel, checkPasswordTextField, passwordInconsistencyErrorLabel])
        stackView.axis = .vertical
        stackView.setCustomSpacing(10, after: nickNameLabel)
        stackView.setCustomSpacing(30, after: nickNameTextField)
        stackView.setCustomSpacing(20, after: nickNameGenerationErrorLabel)
        stackView.setCustomSpacing(10, after: passwordLabel)
        stackView.setCustomSpacing(30, after: passwordTextField)
        stackView.setCustomSpacing(20, after: passwordGenerationErrorLabel)
        stackView.setCustomSpacing(10, after: checkPasswordLabel)
        
        contentView.addSubview(numberLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailBoxLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(nextButton)
        
        numberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }
        
        emailBoxLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.06)
            make.height.equalTo(41)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(emailBoxLabel.snp.bottom).offset(18)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.06)
        }
        
        nextButton.snp.makeConstraints { make in
            let width = scrollView.frame.width - contentView.frame.width
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.04 + width)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
        }
    }
    
    @objc func scrollViewTapped() {
        scrollView.endEditing(true)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped() {
        if let nickname = nickNameTextField.text, let password = passwordTextField.text {
            if isValidNickName(nickname) && isValidPassword(password) && passwordTextField.text == checkPasswordTextField.text {
                if let email = UserSession.shared.signUpEmail {
                    register(nickname: nickname, email: email, password: password)
                }
            }
        }
    }
    
    func isValidNickName(_ nickname: String) -> Bool {
        if (2...6).contains(nickname.count) {
            return true
        } else {
            return false
        }
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[$@$#!%*?&/])[A-Za-z[0-9]$@$#!%*?&/]{8,15}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    // MARK: - Keyboard Handling
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    private func register(nickname: String, email: String, password: String) {
        UserService.shared.register(nickname:nickname, email: email, password: password) { response in
            switch response {
            case .success(let data):
                self.nextButton.isEnabled = true
                if data.resultCode == 200 {
                    print("이백")
                    UserSession.shared.signUpNickname = data.account?.nickname
                    self.navigationController?.pushViewController(FinishSignUpViewController(), animated: true)
                } else if data.resultCode == 500 {
                    print("오백")
                }
            case .failure:
                print("failure")
                self.nextButton.isEnabled = true
            }
        }
    }
}

extension EnterProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nickNameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            checkPasswordTextField.becomeFirstResponder()
        case checkPasswordTextField:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let updatedText = textField.text else { return }
        
        switch textField.tag {
        case 1:
            if isValidNickName(updatedText) {
                stackView.setCustomSpacing(30, after: nickNameTextField)
                nickNameGenerationErrorLabel.isHidden = true
            } else {
                stackView.setCustomSpacing(15, after: nickNameTextField)
                nickNameGenerationErrorLabel.isHidden = false
            }
        case 2:
            if isValidPassword(updatedText) {
                stackView.setCustomSpacing(30, after: passwordTextField)
                passwordGenerationErrorLabel.isHidden = true
            } else {
                stackView.setCustomSpacing(15, after: passwordTextField)
                passwordGenerationErrorLabel.isHidden = false
            }
        case 3:
            if updatedText == passwordTextField.text {
                stackView.setCustomSpacing(30, after: checkPasswordTextField)
                passwordInconsistencyErrorLabel.isHidden = true
            } else {
                stackView.setCustomSpacing(15, after: checkPasswordTextField)
                passwordInconsistencyErrorLabel.isHidden = false
            }
        default:
            break
        }

        let isNickNameValid = isValidNickName(nickNameTextField.text ?? "")
        let isPasswordValid = isValidPassword(passwordTextField.text ?? "")
        let isPasswordMatched = passwordTextField.text == checkPasswordTextField.text
        
        if isNickNameValid && isPasswordValid && isPasswordMatched {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
}

extension EnterProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let navigationBar = navigationController?.navigationBar

        let maxOffsetY = UIScreen.main.bounds.height * 0.15
        let alpha = 1 - min(1, max(0, offsetY / maxOffsetY))
        navigationBar?.alpha = alpha
    }
}

extension EnterProfileViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

extension EnterProfileViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
