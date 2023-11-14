//
//  EnterCodeViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/02.
//

import UIKit

class EnterCodeViewController: UIViewController {
    private let numberLabel: UILabel = LabelManager.shared.createSignUpNumberLabel(text: "2/3")
    private let titleLabel: UILabel = LabelManager.createSignUpTitleLabel(text: "전송된 인증코드를\n입력해 주세요")
    private let subTitleLabel: UILabel = LabelManager.createSignUpSubtitleLabel(text: "인증코드", textColor: UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1))
    private let firstLabel: UILabel = LabelManager.shared.createCodeLabel()
    private let secondLabel: UILabel = LabelManager.shared.createCodeLabel()
    private let thirdLabel: UILabel = LabelManager.shared.createCodeLabel()
    private let fourthLabel: UILabel = LabelManager.shared.createCodeLabel()
    private let fifthLabel: UILabel = LabelManager.shared.createCodeLabel()
    private let sixthLabel: UILabel = LabelManager.shared.createCodeLabel()
    private let codeTextField: UITextField = TextFieldManager.shared.createSignUpCodeTextField()
    private let stackView: UIStackView = StackViewManager.shared.getHorizontalStackView()
    private let errorLabel = LabelManager.shared.getErrorLabel(text: "유효하지 않은 인증코드입니다.")
    private let nextButton = ButtonManager.shared.getNextButton(isEnabled: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
            
        setupDelegate()
        setupUI()
        setupTapGesture()
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing)))
        
        let inputlabels = [firstLabel, secondLabel, thirdLabel, fourthLabel, fifthLabel, sixthLabel]
        inputlabels.forEach { label in
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped)))
        }
    }
    
    private func setupDelegate() {
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        codeTextField.delegate = self
    }
    
    private func setupUI() {
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction: #selector(backButtonTapped), title: "", showSeparator: false)
        
        view.addSubview(numberLabel)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(codeTextField)
        view.addSubview(stackView)
        view.addSubview(errorLabel)
        view.addSubview(nextButton)
        
        let inputLabels = [firstLabel, secondLabel, thirdLabel, fourthLabel, fifthLabel, sixthLabel]
        for i in inputLabels {
            stackView.addArrangedSubview(i)
        }
        
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
        
        codeTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-100)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.06)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.06)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }
        
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.04)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
        }
    }
    
    @objc func labelTapped() {
        codeTextField.becomeFirstResponder()
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped() {
        if let code = codeTextField.text, let email = UserSession.shared.signUpEmail {
            self.nextButton.isEnabled = false
            codeCheck(email: email, code: code)
        }
    }
    
    private func codeCheck(email: String, code: String) {
        UserService.shared.codeCheck(email: email, code: code) { result in
            switch result {
            case .success(let data):
                self.nextButton.isEnabled = true
                if data.resultCode == 200 {
                    print("이백")
                    self.errorLabel.isHidden = true
                    self.navigationController?.pushViewController(EnterProfileViewController(), animated: true)
                } else if data.resultCode == 500 {
                    print("오백")
                    self.errorLabel.isHidden = false
                }
            case .failure:
                print("failure")
                self.nextButton.isEnabled = true
                self.errorLabel.isHidden = false
            }
        }
    }    
}

extension EnterCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
                
        nextButton.isEnabled = false
        if updatedText.isEmpty {
            firstLabel.text = ""
        } else if updatedText.count == 1 {
            firstLabel.text = String(updatedText[updatedText.index(updatedText.startIndex, offsetBy: 0)])
            secondLabel.text = ""
        } else if updatedText.count == 2 {
            secondLabel.text = String(updatedText[updatedText.index(updatedText.startIndex, offsetBy: 1)])
            thirdLabel.text = ""
        } else if updatedText.count == 3 {
            thirdLabel.text = String(updatedText[updatedText.index(updatedText.startIndex, offsetBy: 2)])
            fourthLabel.text = ""
        } else if updatedText.count == 4 {
            fourthLabel.text = String(updatedText[updatedText.index(updatedText.startIndex, offsetBy: 3)])
            fifthLabel.text = ""
        } else if updatedText.count == 5 {
            fifthLabel.text = String(updatedText[updatedText.index(updatedText.startIndex, offsetBy: 4)])
            sixthLabel.text = ""
        } else if updatedText.count == 6 {
            nextButton.isEnabled = true
            sixthLabel.text = String(updatedText[updatedText.index(updatedText.startIndex, offsetBy: 5)])
            DispatchQueue.main.async {
                textField.resignFirstResponder()
            }
        }
        return updatedText.count <= 6
    }
}

extension EnterCodeViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

extension EnterCodeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
