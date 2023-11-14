//
//  AddViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/10/06.
//

import UIKit
import SnapKit

class AddViewController: UIViewController {
    
    let emailLabel = LabelManager.shared.getAddEmailLabel()
    var emailTextField = TextFieldManager.shared.getAddEmailTextField()
    var addFriendButton = ButtonManager.shared.getAddFriendButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addFunction()
    }
    
    private func setUI(){
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(addFriendButton)
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(21)
            make.width.equalTo(37)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(45)
        }
        
        addFriendButton.snp.makeConstraints { make in
            make.width.equalTo(106)
            make.height.equalTo(35)
            make.right.equalTo(emailTextField.snp.right)
            make.top.equalTo(emailTextField.snp.bottom).offset(13)
        }
    }
    
    private func addFunction(){
        addFriendButton.addTarget(self, action: #selector(tapAddFriendButton), for: .touchDown)
    }
    
    @objc private func tapAddFriendButton(){
        request(email: emailTextField.text ?? "")
    }
    


}
extension AddViewController{
    private func request(email: String){
        FriendService.shared.requestFriend(email: email) { (response) in
            switch(response){
            case .success(let data):
                if let result = data as? ResultCodeResponse{
                    if result.resultCode == 200 {
                        print("request friend 200")
                    }else{
                        print("request friend error")
                    }
                }
                
            case .failure(let error):
                print(error)
            
            }
        }
    }
}
