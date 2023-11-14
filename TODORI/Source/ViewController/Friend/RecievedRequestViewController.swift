//
//  RecievedRequestViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/10/06.
//

import UIKit


class RecievedRequestViewController: UIViewController {
    var tableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .none
        return tableview
    }()
    var friendArray: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FriendService.shared.searchRequest { (response) in
            switch(response){
            case .success(let data):
                if let result = data as? FriendResponseData{
                    if result.resultCode == 200 {
                        print("friend request 200")
                        self.friendArray = result.data
                        self.tableView.reloadData()
                        
                    }else{
                        print("friend request 500")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setUI(){
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
    }
}
extension RecievedRequestViewController: UITableViewDelegate{
    
}

extension RecievedRequestViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("friend array count: \(friendArray.count)")
        return friendArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RecievedRequestTableViewCell()
        let friend = friendArray[indexPath.row]
        cell.emailLabel.text = friend.email
        cell.nicknameLabel.text = friend.nickname
        cell.friend = friend
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }


}
