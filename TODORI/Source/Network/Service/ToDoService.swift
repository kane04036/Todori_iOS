//
//  ToDoService.swift
//  TODORI
//
//  Created by Dasol on 2023/05/25.
//

import UIKit
import Alamofire

class TodoService {
    static let shared = TodoService()
    
    private init() {}
    
    func inquireGroupName(completion: @escaping(Result<ToDoResponse, Error>) -> Void) {
        let url = APIConstant.ToDo.groupName
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        let headers: HTTPHeaders = ["Authorization" : "Token " + token]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: ToDoResponse.self) { response in
            switch response.result {
            case .success(let response):
                print("투두 조회 성공 in UserService")
                completion(.success(response))
                
            case .failure(let error):
                print("투두 조회 실패 in UserService")
                completion(.failure(error))
            }
        }
    }
    
    func editGroupName(first: String, second: String, third: String, fourth: String, fifth: String, sixth: String, completion: @escaping(Result<ResultCodeResponse, Error>) -> Void) {
        let url = APIConstant.ToDo.groupName
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        
        let headers: HTTPHeaders = ["Authorization" : "Token " + token]
        let parameters: [String: Any] = [
            "priority": [
                "1": first,
                "2": second,
                "3": third,
                "4": fourth,
                "5": fifth,
                "6": sixth
            ]
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: ResultCodeResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print("투두 수정 성공 in UserService")
                    completion(.success(response))
                case .failure(let error):
                    print("투두 수정 실패 in UserService: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func searchTodo(year:String, month:String, day:String, completion:@escaping(AFResult<Any>)->Void){
        let url = APIConstant.baseURL + APIConstant.todo
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        let parameter:Parameters = [
            "year":year,
            "month": month,
            "day":day
        ]
        AF.request(url, method: .get,parameters: parameter, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: TodoSearchResponseData.self) { response in
                switch response.result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
        
    }
    
    func deleteTodo(id:Int, completion:@escaping(AFResult<Any>)->Void){
        let url = APIConstant.baseURL + APIConstant.todo + "\(id)/"
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        
        
        AF.request(url, method: .delete,headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ResponseData.self) { response in
                switch response.result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func writeTodo(year:String, month:String, day:String, title:String, color:Int, completion:@escaping(AFResult<Any>)->Void){
        let url = APIConstant.baseURL + APIConstant.todo
        
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        let parameter:Parameters = [
            "year":year,
            "month": month,
            "day":day,
            "title":title,
            "color":color
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameter,
                   encoding: JSONEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: TodoWriteResponseData.self) { response in
            switch response.result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func editTodo(title:String, description:String,colorNum:Int, time:String, id:Int, completion:@escaping(AFResult<Any>)->Void){
        let url = APIConstant.baseURL + APIConstant.todo + "\(id)/"
        
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        let parameter:Parameters = [
            "title" : title,
            "description": description,
            "color" : colorNum,
            "time" : time
        ]
        AF.request(url,
                   method: .put,
                   parameters: parameter,
                   encoding: JSONEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: TodoEditResponseData.self) { response in
            switch response.result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func editTodo(todo:ToDo, completion:@escaping(AFResult<Any>)->Void){
        let url = APIConstant.baseURL + APIConstant.todo + "\(todo.id)/"
        
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
                
        let parameter:Parameters = [
            "title" : todo.title,
            "description": todo.description,
            "color" : todo.color,
            "time" : todo.time,
            "year" : todo.year,
            "month" : todo.month,
            "day" : todo.day
        ]
        
        AF.request(url,
                   method: .put,
                   parameters: parameter,
                   encoding: JSONEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: TodoEditResponseData.self) { response in
            switch response.result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    
    func getPriorityName(completion:@escaping(AFResult<Any>)->Void){
        let url = APIConstant.baseURL + APIConstant.category
        
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: PriorityResponseData.self) { response in
            switch response.result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func editDoneTodo(done:Bool, id:Int, completion:@escaping(AFResult<Any>)->Void){
        let url = APIConstant.baseURL + APIConstant.todo + "\(id)/"
        
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        let parameter:Parameters = [
            "done":done
        ]
        AF.request(url,
                   method: .put,
                   parameters: parameter,
                   encoding: JSONEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: TodoEditResponseData.self) { response in
            switch response.result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func postponeTodo(todo:ToDo, completion:@escaping(AFResult<Any>)->Void){
        let url = APIConstant.baseURL + APIConstant.todo
        
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        var components = DateComponents(year: Int(todo.year), month: Int(todo.month), day: Int(todo.day))
        let since = Calendar.current.date(from: components)!
        let tomorrow = Date(timeInterval: 86400, since: since)
        let resultDate = DateFormat.shared.getYearMonthDayDictionary(date: tomorrow)
        
        let parameter:Parameters = [
            "year":resultDate["year"]!,
            "month": resultDate["month"]!,
            "day": resultDate["day"]!,
            "title": todo.title,
            "color": todo.color,
            "description": todo.description,
            "time": todo.time
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameter,
                   encoding: JSONEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: TodoWriteResponseData.self) { response in
            switch response.result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func getDayOfDot(year:Int, month:Int, completion:@escaping(AFResult<Any>) -> Void){
        let url = APIConstant.testURL + APIConstant.day
        
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        let parameters: Parameters = [
            "year" : year,
            "month" : month
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: header)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: DayDotResponseData.self) { response in
            switch response.result{
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
