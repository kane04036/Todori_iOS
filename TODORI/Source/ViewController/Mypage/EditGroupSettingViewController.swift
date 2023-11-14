//
//  EditGroupSettingViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/16.
//

import UIKit

class EditGroupSettingViewController: UIViewController {
    var color: String?
    var label: String?
    var index: String?
    
    private func createStackView(image: String, text: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.snp.makeConstraints() { make in
            make.height.equalTo(41)
        }
        
        let imageView = UIImageView(image: UIImage(named: image))
        imageView.contentMode = .scaleAspectFit
        stackView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(28)
        }
        
        let textField = UITextField()
        textField.becomeFirstResponder()
        textField.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        textField.layer.cornerRadius = 8
        
        stackView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        textField.delegate = self
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        ]
        if let label = self.label {
            let attributedPlaceholder = NSAttributedString(string: label, attributes: attributes)
            textField.attributedPlaceholder = attributedPlaceholder
        }
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textField)
        
        if let index = stackView.arrangedSubviews.firstIndex(of: textField) {
            stackView.setCustomSpacing(10, after: stackView.arrangedSubviews[index - 1])
        }
        return stackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        setupUI()
        
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.view.endEditing(true)
    }

    
    private func setupUI() {
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction: #selector(backButtonTapped), title: "그룹 설정", showSeparator: false)
        navigationItem.rightBarButtonItem = NavigationBarManager.shared.getCompleteBarButtonItem(target: self, selector: #selector(completeButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        
        guard let color = color, let label = label else { return }
        
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.addArrangedSubview(createStackView(image: color, text: label))
        view.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(28)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButtonTapped() {
        guard let first = GroupData.shared.firstGroupName,
              let second = GroupData.shared.secondGroupName,
              let third = GroupData.shared.thirdGroupName,
              let fourth = GroupData.shared.fourthGroupName,
              let fifth = GroupData.shared.fifthGroupName,
              let sixth = GroupData.shared.sixthGroupName
        else { return }

        if let index = index, let label = label {
            navigationItem.rightBarButtonItem?.isEnabled = false
            switch index {
            case "1":
                GroupData.shared.firstGroupName = label
                editGroupName(first: label, second: second, third: third, fourth: fourth, fifth: fifth, sixth: sixth)
            case "2":
                GroupData.shared.secondGroupName = label
                editGroupName(first: first, second: label, third: third, fourth: fourth, fifth: fifth, sixth: sixth)
            case "3":
                GroupData.shared.thirdGroupName = label
                editGroupName(first: first, second: second, third: label, fourth: fourth, fifth: fifth, sixth: sixth)
            case "4":
                GroupData.shared.fourthGroupName = label
                editGroupName(first: first, second: second, third: third, fourth: label, fifth: fifth, sixth: sixth)
            case "5":
                GroupData.shared.fifthGroupName = label
                editGroupName(first: first, second: second, third: third, fourth: fourth, fifth: label, sixth: sixth)
            case "6":
                GroupData.shared.sixthGroupName = label
                editGroupName(first: first, second: second, third: third, fourth: fourth, fifth: fifth, sixth: label)
            default:
                break
            }
        }
    }
    
    func editGroupName(first: String, second: String, third: String, fourth: String, fifth: String, sixth: String) {
        TodoService.shared.editGroupName(first: first, second: second, third: third, fourth: fourth, fifth: fifth, sixth: sixth) { result in
            switch result {
            case .success(let response):
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                if response.resultCode == 200 {
                    print("이백")
                    NotificationCenter.default.post(name: NSNotification.Name("endEditGroupName"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                } else if response.resultCode == 500 {
                    print("오백")
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}

extension EditGroupSettingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let updatedText = textField.text {
            if updatedText.count != 0 {
                navigationItem.rightBarButtonItem?.tintColor = .black
                label = updatedText
            } else {
                navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let enteredText = textField.text {
            label = enteredText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditGroupSettingViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

extension EditGroupSettingViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
