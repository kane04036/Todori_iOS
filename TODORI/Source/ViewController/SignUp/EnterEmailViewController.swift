//
//  EnterEmailViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/01.
//

import UIKit

class EnterEmailViewController: UIViewController {
    private let numberLabel: UILabel = LabelManager.shared.createSignUpNumberLabel(text: "1/3")
    private let titleLabel: UILabel = LabelManager.createSignUpTitleLabel(text: "이메일을\n입력해 주세요")
    private let subTitleLabel: UILabel = LabelManager.createSignUpSubtitleLabel(text: "이메일", textColor: UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1))
    private let emailTextField: UITextField = TextFieldManager.createSignUpEmailTextField(text: "example@todori.com")
    private let errorLabel: UILabel = LabelManager.shared.getErrorLabel(text: "이미 존재하는 이메일입니다.")
    private let nextButton: UIButton = ButtonManager.shared.getNextButton(isEnabled: false)
    private let indicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupDelegate()
        setupUI()
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    private func setupDelegate() {
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        emailTextField.delegate = self
    }

    private func setupUI() {
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction: #selector(backButtonTapped), title: "", showSeparator: false)

        view.addSubview(numberLabel)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(errorLabel)
        view.addSubview(nextButton)
        view.addSubview(indicatorView)

        numberLabel.snp.makeConstraints { make in
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let topSafeAreaHeight = windowScene.windows.first?.safeAreaInsets.top,
               let navigationBarHeight = navigationController?.navigationBar.frame.height {
                let totalHeight = topSafeAreaHeight + navigationBarHeight
                make.top.equalToSuperview().offset(totalHeight + 40)
            }
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.06)
        }

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }

        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.04)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped() {
        if let email = emailTextField.text {
            nextButton.isEnabled = false
            indicatorView.startAnimating()
            emailCheck(email: email)
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func emailCheck(email: String) {
        UserService.shared.emailCheck(email: email) { result in
            switch result {
            case .success(let data):
                self.indicatorView.stopAnimating()
                self.nextButton.isEnabled = true
                if data.resultCode == 200 {
                    print("이백")
                    self.errorLabel.isHidden = true
                    UserSession.shared.signUpEmail = self.emailTextField.text
                    self.navigationController?.pushViewController(EnterCodeViewController(), animated: true)
                }
                else if data.resultCode == 500 {
                    print("오백")
                    self.errorLabel.isHidden = false
                }
            case .failure:
                print("failure")
                self.errorLabel.isHidden = false
                self.indicatorView.stopAnimating()
                self.nextButton.isEnabled = true
            }
        }
    }
}

extension EnterEmailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if isValidEmail(newText) {
            let imageView = UIImageView(image: UIImage(named: "email-check")?.resize(to: CGSize(width: 28, height: 28)))
            imageView.contentMode = .scaleAspectFit
            textField.rightView = imageView
            textField.rightViewMode = .always
            nextButton.isEnabled = true
        } else {
            textField.rightView = nil
            textField.rightViewMode = .never
            nextButton.isEnabled = false
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EnterEmailViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

extension EnterEmailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
