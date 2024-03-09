//
//  DeleteFriendTableViewCell.swift
//  TODORI
//
//  Created by 제임스 on 2023/10/13.
//

import UIKit

class DeleteFriendTableViewCell: UITableViewCell {
    var imageString: String?
    var imageData: UIImage?
    var profileImageView: UIImageView = ImageViewManager.shared.getRequestProfileImageView()
    var nicknameLabel: UILabel = LabelManager.shared.getFriendNicknameLabel()
    var deleteButton: UIButton = ButtonManager.shared.getDeleteFriendButton()
    var background: UIView = UIView()
    var friend: Friend?
    var delegate: DeleteFriendTableViewCellDelegate?
    var deleteButtonFunction: () -> Void
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    init(buttonFunction: @escaping () -> Void) {
        self.deleteButtonFunction = buttonFunction
        super.init(style: .default, reuseIdentifier: "RequestCell")

        if let image = imageString {
            imageData = UserSession.shared.base64StringToImage(base64String: image)
            profileImageView.image = imageData
        }else {
            profileImageView.image = UIImage(named: "default-profile")
        }
        setUI()
        addFunction()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addFunction(){
        deleteButton.addTarget(self, action: #selector(tapDeleteButton), for: .touchDown)
    }
    
    private func setUI(){
        background.addSubViews([profileImageView, nicknameLabel, deleteButton])
        self.contentView.addSubview(background)

        background.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.left.equalToSuperview().offset(27)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-27)
            make.centerY.equalToSuperview()
            make.width.equalTo(66)
            make.height.equalTo(28)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        

    }
    
    @objc private func tapDeleteButton(){
//        deleteButtonFunction()
        guard let friend = friend else {print("no friend");return}
        FriendService.shared.deleteFriend(friend: friend) { response in
            switch(response){
            case .success(let data):
                if let result = data as? ResultCodeResponse {
                    if result.resultCode == 200 {
                        self.delegate?.deleteFriend(friend: friend)
                        print("del friend 200")
                    }else {
                        print("del friend error")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

protocol DeleteFriendTableViewCellDelegate: AnyObject {
    func deleteFriend(friend: Friend)
}
