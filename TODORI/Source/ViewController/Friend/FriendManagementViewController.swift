//
//  FriendManagementViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/10/04.
//

import UIKit
import SnapKit

class FriendManagementViewController: UIViewController{
    
    var myFriendButton: UIButton = ButtonManager.shared.getFriendManagementBlackButton(title: "나의 친구")
    var recievingRequestButton: UIButton = ButtonManager.shared.getFriendManagementGrayButton(title: "받은 요청")
    var addButton: UIButton = ButtonManager.shared.getFriendManagementGrayButton(title: "추가")
    var selectedBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    var grayBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        return view
    }()
    
    var redbutton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("버튼버튼", for: .normal)
        return button
    }()
    
    var buttonStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        stackview.contentMode = .scaleAspectFill
        return stackview
    }()
    
    var switchView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addFunction()
        changeView(viewController: MyFriendViewController())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction: #selector(backButtonTapped), title: "친구관리", showSeparator: false)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func setUI(){
        self.view.backgroundColor = .white
        
//        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction: #selector(backButtonTapped), title: "친구관리", showSeparator: false)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        buttonStackView.addArrangedSubviews([myFriendButton, recievingRequestButton, addButton])
        self.view.addSubview(buttonStackView)
        self.view.addSubview(selectedBarView)
        self.view.addSubview(grayBarView)
        self.view.addSubview(switchView)
                
        buttonStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        grayBarView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
        
        selectedBarView.snp.makeConstraints { make in
            make.bottom.equalTo(grayBarView.snp.bottom)
            make.width.equalTo(self.view.fs_width/3)
            make.height.equalTo(2)
            make.left.equalToSuperview()
        }
        
        switchView.snp.makeConstraints { make in
            make.top.equalTo(grayBarView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func addFunction(){
        myFriendButton.addTarget(self, action: #selector(tapMyFriendButton), for: .touchDown)
        recievingRequestButton.addTarget(self, action: #selector(tapRecieveRequestButton), for: .touchDown)
        addButton.addTarget(self, action: #selector(tapAddButton), for: .touchDown)
    }
    
    @objc private func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func tapMyFriendButton(){
        myFriendButton.setTitleColor(.black, for: .normal)
        recievingRequestButton.setTitleColor(.gray, for: .normal)
        addButton.setTitleColor(.gray, for: .normal)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.selectedBarView.snp.remakeConstraints { make in
                make.bottom.equalTo(self.grayBarView.snp.bottom)
                make.width.equalTo(self.view.fs_width/3)
                make.height.equalTo(2)
                make.left.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        })
        
        changeView(viewController: MyFriendViewController())
    }
    
    @objc private func tapRecieveRequestButton(){
        myFriendButton.setTitleColor(.gray, for: .normal)
        recievingRequestButton.setTitleColor(.black, for: .normal)
        addButton.setTitleColor(.gray, for: .normal)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.selectedBarView.snp.remakeConstraints { make in
                make.bottom.equalTo(self.grayBarView.snp.bottom)
                make.width.equalTo(self.view.fs_width/3)
                make.height.equalTo(2)
                make.centerX.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        })
        
        changeView(viewController: RecievedRequestViewController())

    }
    
    @objc private func tapAddButton(){
        myFriendButton.setTitleColor(.gray, for: .normal)
        recievingRequestButton.setTitleColor(.gray, for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.selectedBarView.snp.remakeConstraints { make in
                make.bottom.equalTo(self.grayBarView.snp.bottom)
                make.width.equalTo(self.view.fs_width/3)
                make.height.equalTo(2)
                make.right.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        })

        changeView(viewController: AddViewController())
    }
    
    private func changeView(viewController: UIViewController){
        let viewController = viewController
        guard let view = viewController.view else {return}
        
        for view in self.switchView.subviews{
            view.removeFromSuperview()
        }
        for viewController in self.children{
            viewController.removeFromParent()
        }
        
        switchView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(switchView)
        }
        self.addChild(viewController)
        
    }
}
