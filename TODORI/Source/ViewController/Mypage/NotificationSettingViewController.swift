//
//  NotificationSettingViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/06/21.
//

import UIKit
import UserNotifications

class NotificationViewController: UIViewController{
    private let notificationTurnOnAndOffLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "알림 켜기/끄기"
        label.textColor = UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let notificationSwitch: UISwitch = {
        let notificationSwitch: UISwitch = UISwitch()
        notificationSwitch.addTarget(NotificationViewController.self, action: #selector(tapSwitch(sender:)), for: .valueChanged)
        notificationSwitch.isEnabled = false
        return notificationSwitch
    }()
    
    private let infoImage: UIImageView = {
        let image: UIImageView = UIImageView(image: UIImage(named: "info"))
        return image
    }()
    
    private let infoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "안내사항"
        label.textColor = UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackview: UIStackView = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 2
        return stackview
    }()
    
    private let paddingViewForStackView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    private let grayLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        return view
    }()
    
    private let infoListLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 1)
        label.numberOfLines = 3
        
        // 원하는 줄 간격 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8

        // NSAttributedString을 사용하여 속성 적용
        let attributedText = NSAttributedString(string: "- 현재 알림 설정은 제공되지 않습니다. (추후 업데이트 예정) \n- 아이폰 설정 > 앱 > 알림에서 설정해 주시기 바랍니다.", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.attributedText = attributedText

        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI(){
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction:  #selector(backButtonTapped), title: "알림 설정", showSeparator: false)
        self.view.backgroundColor = .white

        infoStackView.addArrangedSubview(infoImage)
        infoStackView.addArrangedSubview(infoLabel)
        
        paddingViewForStackView.addSubview(infoStackView)

        self.view.addSubview(notificationTurnOnAndOffLabel)
        self.view.addSubview(notificationSwitch)
        self.view.addSubview(grayLine)
        self.view.addSubview(paddingViewForStackView)
        self.view.addSubview(infoListLabel)
        
        
        notificationTurnOnAndOffLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(32)
            make.left.equalToSuperview().offset(26)
        }
        
        notificationSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(notificationTurnOnAndOffLabel)
            make.right.equalToSuperview().offset(-20)
        }
        
        grayLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.right.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(notificationTurnOnAndOffLabel.snp.bottom).offset(24)
        }
        
        infoImage.snp.makeConstraints { make in
            make.width.height.equalTo(14)
        }
        
        paddingViewForStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(grayLine.snp.bottom).offset(22)
            make.height.equalTo(29)
            make.width.equalTo(80)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        infoListLabel.snp.makeConstraints { make in
            make.top.equalTo(paddingViewForStackView.snp.bottom).offset(13)
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
    }
    

    @objc func tapSwitch(sender: UISwitch){
        if sender.isOn {
            
        }else {
            
        }
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
