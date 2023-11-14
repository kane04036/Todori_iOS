//
//  ResponseModel.swift
//  TODORI
//
//  Created by Dasol on 2023/05/24.
//

import Foundation

struct ResultCodeResponse: Decodable {
    let resultCode: Int
}

struct RegisterResponse: Decodable {
    let resultCode: Int
    let account: AccountResponse?
}

struct AccountResponse: Decodable {
    let nickname: String
    let email: String
}

struct LoginResponse: Decodable {
    let resultCode: Int
    let token: String?
    let nickname: String?
    let email: String?
    let image: String?
}

struct EditAccountResponse: Decodable {
    let resultCode: Int
    let data: DataResponse?
}

struct DataResponse: Decodable {
    let nickname: String
    let image: String?
}

struct ToDoResponse: Decodable {
    let resultCode: Int
    let data: [String: String]
}

struct ResponseData : Codable{
    let resultCode:Int
}

struct RegisterResponseData :Codable{
    let account : Account
    let resultCode : Int
}
struct Account:Codable{
    let nickname:String
    let email:String
}

struct LoginResponseData:Codable{
    let resultCode:Int
    let token:String?
    let nickname:String?
    let email:String?
    let image:String?
}

struct TodoWriteResponseData:Codable{
    let resultCode:Int
    let data:TodoResonseData
}

struct TodoSearchResponseData:Codable{
    let resultCode:Int
    let data:[TodoResonseData]
}

struct TodoResonseData:Codable{
    let title:String
    let year:Int
    let month:Int
    let day:Int
    let writer:String
    let done:Bool
    let color:Int
    let time:String
    let description:String
    let id:Int
}
struct TodoEditResponseData:Codable{
    let resultCode:Int
    let data : TodoEditResonseDataList
}

struct TodoEditResonseDataList:Codable{
    let title:String
    let year:Int
    let month:Int
    let day:Int
    let done:Bool
    let color:Int
    let time:String
    let description:String
    let id:Int
}

struct EditImageAndNicknameResonseData:Codable{
    let resultCode:Int
    let data : ImageAndNickname
}
struct ImageAndNickname:Codable{
    let nickname:String
    let image:String
}

struct PriorityResponseData:Codable{
    let resultCode:Int
    let data:Category
}

struct SearchColorArrayResponseData:Codable{
    let resultCode:Int
    let data:[ColorNumberPair]
}

struct ColorNumberPair:Codable{
    let num:[Int]
}
    
struct CategoryResponseData:Codable{
    let resultCode:Int
    let data:Category
}

struct Category:Codable{
    let _1:String
    let _2:String
    let _3:String
    let _4:String
    let _5:String
    let _6:String
    
    enum CodingKeys:String, CodingKey{
        case _1 = "1"
        case _2 = "2"
        case _3 = "3"
        case _4 = "4"
        case _5 = "5"
        case _6 = "6"
    }
}

struct DayDotResponseData: Codable{
    let resultCode: Int
    let data: [Int]
}

struct FriendResponseData: Codable{
    let resultCode: Int
    let data: [Friend]
}

        
        
