//
//  MyFriendViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/10/06.
//

import UIKit
import SnapKit

class MyFriendViewController: UIViewController {
    var entireButton = ButtonManager.shared.getManagementButton(title: "전체")
    var favoriteButton = ButtonManager.shared.getManagementButton(title: "즐겨찾기")
    var managementButton = ButtonManager.shared.getManagementButton(title: "관리하기")
    var tabStatus: Int = 0 //전체: 0, 즐겨찾기: 1, 관리하기: 2
    var tableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .none
        return tableview
    }()
    var buttonStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .equalSpacing
        stackview.spacing = 8
        return stackview
    }()
    
    let orangeBorderColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1).cgColor
    let orangeBackgroundColor = UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
    let grayBorderColor = UIColor(red: 0.867, green: 0.859, blue: 0.859, alpha: 1).cgColor
    
    var friendList: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addFunction()
        searchFriend()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUI(){
        buttonStackView.addArrangedSubviews([entireButton, favoriteButton, managementButton])
        self.view.addSubViews([buttonStackView, tableView])
        entireButton.layer.borderColor = orangeBorderColor
        entireButton.backgroundColor = orangeBackgroundColor
        
        entireButton.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.width.equalTo(51)
        }

        favoriteButton.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.width.equalTo(68)
        }
        
        managementButton.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.width.equalTo(68)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(29)
            make.left.equalToSuperview().offset(25)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
                
    }
    
    private func addFunction(){
        entireButton.addTarget(self, action: #selector(tapEntireButton), for: .touchDown)
        favoriteButton.addTarget(self, action: #selector(tapFavoriteButton), for: .touchDown)
        managementButton.addTarget(self, action: #selector(tapManagementButton), for: .touchDown)
    }
    
    @objc private func tapEntireButton(){
        setTapButtonColorSetting(selectedButton: entireButton, deselectedButtons: [favoriteButton, managementButton])
        tabStatus = 0
        searchFriend()
    }
    
    @objc private func tapFavoriteButton(){
        setTapButtonColorSetting(selectedButton: favoriteButton, deselectedButtons: [entireButton, managementButton])
        tabStatus = 1
        deleteNoStarFriend()
    }
    
    @objc private func tapManagementButton(){
        setTapButtonColorSetting(selectedButton: managementButton, deselectedButtons: [entireButton, favoriteButton])
        tabStatus = 2
        searchFriend()
        sortByNickname()
    }
    
    private func setTapButtonColorSetting(selectedButton: UIButton, deselectedButtons: [UIButton]){
        selectedButton.layer.borderColor = orangeBorderColor
        selectedButton.backgroundColor = orangeBackgroundColor
        
        deselectedButtons.forEach { button in
            button.layer.borderColor = grayBorderColor
            button.backgroundColor = .white
        }
    }
    
    private func sortByStar(){
        friendList.sort { friend1, friend2 in
            if let star1 = friend1.star, let star2 = friend2.star {
                return star1 && !star2
            }
            return false
        }
    }
    
    private func sortByNickname(){
        friendList.sort { friend1, friend2 in
            return friend1.nickname < friend2.nickname
        }
    }
    
    private func deleteNoStarFriend(){
        friendList.removeAll { friend in
            friend.star == false
        }
        tableView.reloadData()
    }
    
}
extension MyFriendViewController{
    private func searchFriend(){
        FriendService.shared.searchFriend { (response) in
            switch(response){
            case .success(let data):
                if let result = data as? FriendResponseData{
                    if result.resultCode == 200 {
                        print("friend 200")
                        self.friendList = result.data
                        self.tableView.reloadData()
                        self.sortByNickname()
                        self.sortByStar()
                    }else{
                        print("request error")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension MyFriendViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
}

extension MyFriendViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friendList[indexPath.row]
        
        switch(tabStatus){
        case 0, 1:
            let cell = FriendTableViewCell()
            cell.imageString = friend.image
            cell.nicknameLabel.text = friend.nickname
            cell.starButton.setImage(friend.star! ? UIImage(named: "star-on") : UIImage(named: "star-off"), for: .normal)
            cell.friend = friend
            cell.delegate = self
            return cell
        case 2:
            let cell = DeleteFriendTableViewCell()
            cell.imageString = friend.image
            cell.nicknameLabel.text = friend.nickname
            return cell
        default:
            let cell = FriendTableViewCell()
            cell.imageString = friend.image
            cell.nicknameLabel.text = friend.nickname
            cell.friend = friend
            return cell
        }
        
    }
}

extension MyFriendViewController: FriendTableViewCellDelegate {
    func updateStar(friend: Friend) {
        if let row = friendList.firstIndex(where: { person in
            person.email == friend.email
        }){
            friendList[row] = friend
            tableView.reloadData()
            sortByNickname()
            sortByStar()
        }
    }
}
