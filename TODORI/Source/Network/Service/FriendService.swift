//
//  FriendService.swift
//  TODORI
//
//  Created by 제임스 on 2023/10/06.
//

import UIKit
import Alamofire

class FriendService {
    static let shared = FriendService()
    
    func searchRequest(completion: @escaping(AFResult<Any>) -> Void){
        let url = APIConstant.baseURL + APIConstant.Friend.searchRequest
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        
        let header: HTTPHeaders = ["Content-Type" : "application/json",
                                   "Authorization": "Token \(token)"]
        
        AF.request(url, method: .post, headers: header).validate(statusCode: 200..<300)
            .responseDecodable(of: FriendResponseData.self) { (response) in
                switch(response.result) {
                case .success(let result):
                    completion(.success(result))
                case.failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func requestFriend(email: String, completion: @escaping(AFResult<Any>) -> Void){
        let url = APIConstant.baseURL + APIConstant.Friend.requestFriend
        
        guard let token = TokenManager.shared.getToken() else {print("no token"); return}
        
        let header: HTTPHeaders = ["Content-Type" : "application/json",
                                   "Authorization": "Token \(token)"]
        
        let parameter: [String: Any] = [
            "receiver" : email
        ]
        
        AF.request(url, method: .post, parameters: parameter,
                   encoding: JSONEncoding.default, headers: header)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: ResultCodeResponse.self) { (response) in
            switch(response.result){
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
        
    }
    
    func searchFriend(completion: @escaping(AFResult<Any>) -> Void){
        let url = APIConstant.baseURL + APIConstant.Friend.searchFriend
        
        guard let token = TokenManager.shared.getToken() else {print("no token"); return}
        print("token: \(token)")
        
        let header: HTTPHeaders = ["Content-Type" : "application/json",
                                   "Authorization": "Token \(token)"]
        
        
        AF.request(url, method: .post, headers: header)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: FriendResponseData.self) { (response) in
            switch(response.result){
            case .success(let data):
                print("friend 200")
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
        
    }
    
    func handleRequest(email: String, requestResult: Int, completion: @escaping(AFResult<Any>) -> Void){
        let url = APIConstant.baseURL + APIConstant.Friend.handleRequest
        let urlComponent = URLComponents(string: url)
        guard let token = TokenManager.shared.getToken() else {print("no token"); return}
        
        let header: HTTPHeaders = ["Content-Type" : "multipart/form-data",
                                   "Authorization": "Token \(token)"]
        
        let parameters: [String: Any] = [
            "check" : requestResult,
            "target" : email
        ]
        
        
        AF.upload(multipartFormData: { MultipartFormData in
            for (key, value) in parameters{
                MultipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
        }, to: url, method: .post, headers: header)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: ResultCodeResponse.self) { (response) in
            switch(response.result){
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setStar(friend: Friend, completion: @escaping(AFResult<Any>) -> Void){
        let url = APIConstant.baseURL + APIConstant.Friend.updateStar
        
        guard let token = TokenManager.shared.getToken() else {print("no token"); return}
        print("token: \(token)")
        
        let header: HTTPHeaders = ["Content-Type" : "application/json",
                                   "Authorization": "Token \(token)"]
        
        guard let isStar = friend.star else {return}
        
        let parameters: [String: Any] = [
            "friend": friend.email,
            "star": !isStar ? 1 : 0
        ]
        
        
        AF.request(url, method: .get,parameters: parameters, encoding: URLEncoding.default, headers: header)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: ResultCodeResponse.self) { (response) in
            switch(response.result){
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
        
    }
    
    
}
