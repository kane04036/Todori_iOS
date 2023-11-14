//
//  RecievedRequestTableViewCell.swift
//  TODORI
//
//  Created by 제임스 on 2023/10/06.
//

import UIKit
import SnapKit
class RecievedRequestTableViewCell: UITableViewCell {
    var friend:Friend?
    var profileImageView: UIImageView = ImageViewManager.shared.getRequestProfileImageView()
    var emailLabel: UILabel = LabelManager.shared.getFriendEmailLabel()
    var nicknameLabel: UILabel = LabelManager.shared.getFriendNicknameLabel()
    var acceptButton: UIButton = ButtonManager.shared.getAcceptButton()
    var rejectButton: UIButton = ButtonManager.shared.getRejectButton()
    var backgroundview: UIView = UIView()
    var labelStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        return stackview
    }()
    
    var buttonStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        return stackview
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("in request cell nib")

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "RequestCell")
        print("in request cell")

        setUI()
        addFunction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addFunction(){
        acceptButton.addTarget(self, action: #selector(tapAcceptButton), for: .touchDown)
        rejectButton.addTarget(self, action: #selector(tapRejectButton), for: .touchDown)
    }
    
    private func setUI(){
        backgroundview.addSubViews([profileImageView, labelStackView, buttonStackView])
        labelStackView.addArrangedSubviews([nicknameLabel, emailLabel])
        buttonStackView.addArrangedSubviews([acceptButton, rejectButton])
        self.contentView.addSubview(backgroundview)
        
        profileImageView.image = UIImage(named: "default-profile")
        
        backgroundview.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(27)
            make.height.width.equalTo(40)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-27)
            make.centerY.equalToSuperview()
            make.height.equalTo(28)
            make.width.equalTo(92)
        }

        labelStackView.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(13)
            make.right.equalTo(buttonStackView.snp.left).offset(-3)
            make.centerY.equalTo(profileImageView)
        }
    }
    
    @objc private func tapAcceptButton(){
        guard let friendInfo = friend else {return}
        handleRequest(email: friendInfo.email, requestResult: 1)
    }
    
    @objc private func tapRejectButton(){
        guard let friendInfo = friend else {return}
        handleRequest(email: friendInfo.email, requestResult: 0)
    }
    private func handleRequest(email: String, requestResult: Int){
        print("email: \(email), result: \(requestResult)")
        FriendService.shared.handleRequest(email: email, requestResult: requestResult) { (response) in
            switch(response){
            case .success(let data):
                if let result = data as? ResultCodeResponse{
                    if result.resultCode == 200 {
                        print("handle request 200")
                    }else{
                        print("handle request 500")
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }

}
