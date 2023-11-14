//
//  AccountService.swift
//  TODORI
//
//  Created by Dasol on 2023/05/02.
//

import UIKit
import Alamofire

class UserService {
    static let shared = UserService()
    
    private init() {}
    
    func emailCheck(email: String, completion: @escaping(Result<ResultCodeResponse, Error>) -> Void) {
        let url = APIConstant.Account.emailCode
        let parameters: Parameters = [
            "email": email
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: ResultCodeResponse.self) { response in
            switch response.result {
            case .success(let response):
                print("이메일 검증 성공 in UserService")
                completion(.success(response))
                
            case .failure(let error):
                print("이메일 검증 실패 in UserService: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func codeCheck(email: String, code: String, completion: @escaping(Result<ResultCodeResponse, Error>) -> Void) {
        let url = APIConstant.Account.emailCode
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        let body: Parameters = [
            "email": email,
            "code": code
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: ResultCodeResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print("코드 검증 성공 in UserService")
                    completion(.success(response))
                case .failure(let error):
                    print("코드 검증 실패 in UserService: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func register(nickname: String, email: String, password: String, completion: @escaping(Result<RegisterResponse, Error>) -> Void) {
        let url = APIConstant.Account.register
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters: Parameters = [
            "nickname": nickname,
            "email": email,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: RegisterResponse.self){ response in
                switch response.result {
                case .success(let response):
                    print("회원가입 성공 in UserService")
                    completion(.success(response))
                case .failure(let error):
                    print("회원가입 실패 in UserService: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let url = APIConstant.Account.login
        let fcmToken = UserDefaults.standard.string(forKey: "fcmToken")
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "fcm_token" : fcmToken
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    print("로그인 성공 in UserService")
                    completion(.success(loginResponse))
                case .failure(let error):
                    print("로그인 실패 in UserService: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func checkToken(completion: @escaping (Result<ResultCodeResponse, Error>) -> Void) {
        let url = APIConstant.Account.checkToken
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        let headers: HTTPHeaders = ["Authorization" : "Token " + token]
        print("token: \(token)")
        AF.request(url, method: .get, headers: headers).responseDecodable(of: ResultCodeResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print("토큰 검증 성공 in UserService")
                    completion(.success(response))
                case .failure(let error):
                    print("토큰 검증 실패 in UserService: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func logout(completion: @escaping(Result<ResultCodeResponse, Error>) -> Void) {
        let url = APIConstant.Account.logout
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization" : "Token " + token
        ]
        
        AF.request(url, method: .post, headers: headers).responseDecodable(of: ResultCodeResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print("로그아웃 성공 in UserService")
                    completion(.success(response))
                case .failure(let error):
                    print("로그아웃 실패 in UserService: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func findPassword(email: String, completion: @escaping(Result<ResultCodeResponse, Error>) -> Void) {
        let url = APIConstant.Account.findPassword
        let body: Parameters = [
            "email": email
        ]
        
        AF.request(url, method: .get, parameters: body).responseDecodable(of: ResultCodeResponse.self) { response in
            switch response.result {
            case .success(let response):
                print("비밀번호 찾기 성공 in UserService")
                completion(.success(response))
            case .failure(let error):
                print("비밀번호 찾기 실패 in UserService: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func editProfile(image: UIImage?, nickname: String, imdel: Bool, completion: @escaping(Result<EditAccountResponse, Error>) -> Void) {
        let url = APIConstant.Account.editProfile
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        let headers: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Authorization" : "Token " + token
        ]
        var parameters: Parameters = [
            "nickname": nickname,
            "imdel": imdel
        ]
        if let image = image {
            parameters["image"] = image
        }
        
        AF.upload(multipartFormData: { MultipartFormData in
            for (key, value) in parameters {
                MultipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let img = image?.pngData() {
                MultipartFormData.append(img, withName: "image", fileName: "\(String(describing: nickname)).jpg", mimeType: "image/jpg")
            }
        }, to: url, method: .post, headers: headers).responseDecodable(of: EditAccountResponse.self) { response in
            switch response.result {
            case .success(let response):
                print("프로필 수정 성공 in UserService")
                completion(.success(response))
            case .failure(let error):
                print("프로필 수정 실패 in UserService: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func changePassword(originPassword: String, newPassword: String ,completion: @escaping(Result<ResultCodeResponse, Error>) -> Void) {
        let url = APIConstant.Account.changePassword
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        let headers: HTTPHeaders = ["Authorization" : "Token " + token]
        let parameters: Parameters = [
            "originpw": originPassword,
            "newpw": newPassword,
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: ResultCodeResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print("비밀번호 수정 성공 in UserService")
                    completion(.success(response))
                case .failure(let error):
                    print("비밀번호 수정 실패 in UserService: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func deleteAccount(completion: @escaping(Result<ResultCodeResponse, Error>) -> Void) {
        let url = APIConstant.Account.withdrawal
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        let headers: HTTPHeaders = ["Authorization" : "Token " + token]
        
        AF.request(url, method: .delete, headers: headers).responseDecodable(of: ResultCodeResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print("탈퇴 성공 in UserService")
                    completion(.success(response))
                case .failure(let error):
                    print("탈퇴 실패 in UserService: \(error)")
                    completion(.failure(error))
                }
            }
    }
}
