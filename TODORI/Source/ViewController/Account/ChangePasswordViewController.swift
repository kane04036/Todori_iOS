//
//  ChangePasswordViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/15.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    var stackView = UIStackView()
    private let presentPasswordLabel: UILabel = LabelManager.shared.getEditTitleLabel(text: "현재 비밀번호") 
    private let presentPasswordTextField: UITextField = TextFieldManager.shared.getPresentPasswordTextField()
    private let presentPasswordErrorLabel: UILabel = LabelManager.shared.getErrorLabel(text: "현재 비밀번호와 일치하지 않습니다.")
    private let newPasswordLabel: UILabel = LabelManager.shared.getEditTitleLabel(text: "새 비밀번호")
    private let newPasswordTextField: UITextField = TextFieldManager.shared.getNewPasswordTextField(tag: 1)
    private let newPasswordErrorLabel: UILabel = LabelManager.shared.getErrorLabel(text: "비밀번호 생성 규칙에 맞지 않습니다.")
    private let checkNewPasswordLabel: UILabel = LabelManager.shared.getEditTitleLabel(text: "새 비밀번호 확인")
    private let checkNewPasswordTextField: UITextField = TextFieldManager.shared.getNewPasswordTextField(tag: 2)
    private let checkNewPasswordErrorLabel: UILabel = LabelManager.shared.getErrorLabel(text: "새 비밀번호가 일치하지 않습니다.")
    private let finishButton: UIButton = ButtonManager.shared.getFinishButton(title: "변경 완료", titleColor: UIColor(red: 0.554, green: 0.554, blue: 0.554, alpha: 1), false)
    private let indicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        presentPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        checkNewPasswordTextField.delegate = self
        
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    private func setupUI() {
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction:  #selector(backButtonTapped), title: "비밀번호 변경", showSeparator: false)
        
        stackView = UIStackView(arrangedSubviews: [presentPasswordLabel, presentPasswordTextField, presentPasswordErrorLabel, newPasswordLabel, newPasswordTextField, newPasswordErrorLabel, checkNewPasswordLabel, checkNewPasswordTextField, checkNewPasswordErrorLabel])
        stackView.axis = .vertical
        stackView.setCustomSpacing(10, after: presentPasswordLabel)
        stackView.setCustomSpacing(20, after: presentPasswordTextField)
        stackView.setCustomSpacing(10, after: newPasswordLabel)
        stackView.setCustomSpacing(20, after: newPasswordTextField)
        stackView.setCustomSpacing(10, after: checkNewPasswordLabel)
        stackView.setCustomSpacing(20, after: checkNewPasswordTextField)
        
        view.addSubview(stackView)
        view.addSubview(finishButton)
        view.addSubview(indicatorView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(32)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        finishButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(52)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func finishButtonTapped() {
        if let password = presentPasswordTextField.text, let newPassword = newPasswordTextField.text {
            if isValidPassword(newPassword) && newPassword == checkNewPasswordTextField.text {
                indicatorView.startAnimating()
                finishButton.isEnabled = false
                changePassword(originPassword: password, newPassword: newPassword)
            }
        }
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[$@$#!%*?&/])[A-Za-z[0-9]$@$#!%*?&/]{8,15}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func changePassword(originPassword: String, newPassword: String) {
        UserService.shared.changePassword(originPassword: originPassword, newPassword: newPassword) { result in
            switch result {
            case .success(let response):
                self.indicatorView.stopAnimating()
                self.finishButton.isEnabled = true
                if response.resultCode == 200 {
                    print("이백")
                    self.stackView.setCustomSpacing(20, after: self.presentPasswordTextField)
                    self.presentPasswordErrorLabel.isHidden = true
                    
                    let dimmingView = UIView(frame: UIScreen.main.bounds)
                    dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    dimmingView.alpha = 0
                    self.view.addSubview(dimmingView)
                    
                    let popupView = OneButtonPopupView(title: "변경 완료", message: "새로운 비밀번호로\n다시 로그인 해주세요.", buttonText: "확인", buttonColor: UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1), dimmingView: dimmingView)
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
                    self.presentPasswordErrorLabel.isHidden = false
                    self.stackView.setCustomSpacing(8, after: self.presentPasswordTextField)
                    self.stackView.setCustomSpacing(16, after: self.presentPasswordErrorLabel)
                }
            case .failure:
                print("failure")
            }
        }
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = textField.text ?? ""
//        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
//
//        var isPasswordValid = false
//        var arePasswordsMatching = false
//
//        switch textField.tag {
//        case 1:
//            isPasswordValid = isValidPassword(newText)
//            print("1: ",isPasswordValid)
//            if isValidPassword(newText) {
//                stackView.setCustomSpacing(20, after: newPasswordTextField)
//                newPasswordErrorLabel.isHidden = true
//            } else {
//                stackView.setCustomSpacing(8, after: newPasswordTextField)
//                stackView.setCustomSpacing(16, after: newPasswordErrorLabel)
//                newPasswordErrorLabel.isHidden = false
//            }
//        case 2:
//            arePasswordsMatching = (newText == newPasswordTextField.text)
//            if newText == newPasswordTextField.text {
//                checkNewPasswordErrorLabel.isHidden = true
//            } else {
//                stackView.setCustomSpacing(8, after: checkNewPasswordTextField)
//                checkNewPasswordErrorLabel.isHidden = false
//            }
//        default:
//            break
//        }
//        print("2: ",isPasswordValid)
//        if isPasswordValid && arePasswordsMatching {
//            finishButton.isEnabled = true
//            finishButton.backgroundColor = UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
//            finishButton.setTitleColor(.black, for: .normal)
//        } else {
//            finishButton.isEnabled = false
//            finishButton.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
//            finishButton.setTitleColor(UIColor(red: 0.554, green: 0.554, blue: 0.554, alpha: 1), for: .normal)
//        }
//        return true
//    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let updatedText = textField.text else { return }
        
        switch textField.tag {
        case 1:
            if isValidPassword(updatedText) {
                stackView.setCustomSpacing(20, after: newPasswordTextField)
                newPasswordErrorLabel.isHidden = true
            } else {
                stackView.setCustomSpacing(8, after: newPasswordTextField)
                stackView.setCustomSpacing(16, after: newPasswordErrorLabel)
                newPasswordErrorLabel.isHidden = false
            }
        case 2:
            if updatedText == newPasswordTextField.text {
                checkNewPasswordErrorLabel.isHidden = true
            } else {
                stackView.setCustomSpacing(8, after: checkNewPasswordTextField)
                checkNewPasswordErrorLabel.isHidden = false
            }
        default:
            break
        }
        
        let isPasswordValid = isValidPassword(newPasswordTextField.text ?? "")
        let arePasswordsMatching = newPasswordTextField.text == checkNewPasswordTextField.text
        if isPasswordValid && arePasswordsMatching {
            finishButton.isEnabled = true
            finishButton.backgroundColor = UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
            finishButton.setTitleColor(.black, for: .normal)
        } else {
            finishButton.isEnabled = false
            finishButton.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
            finishButton.setTitleColor(UIColor(red: 0.554, green: 0.554, blue: 0.554, alpha: 1), for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case presentPasswordTextField:
            newPasswordTextField.becomeFirstResponder()
        case newPasswordTextField:
            checkNewPasswordTextField.becomeFirstResponder()
        case checkNewPasswordTextField:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}

extension ChangePasswordViewController: OneButtonPopupViewDelegate {
    func buttonTappedDelegate() {
        NavigationBarManager.shared.removeSeparatorView()
        SceneDelegate.reset()
    }
}

extension ChangePasswordViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

extension ChangePasswordViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
