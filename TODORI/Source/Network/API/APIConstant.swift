//
//  APIConstant.swift
//  TODORI
//
//  Created by Dasol on 2023/05/01.
//

import Foundation

enum APIConstant {
    static let baseURL = "http:35.225.210.179:8000"
    static let testURL = "http:35.225.210.179:8000"
    
    enum Account {
        static let emailCode = baseURL + "/account/emailcode/"
        static let login = baseURL + "/account/login/"
        static let logout = baseURL + "/account/logout/"
        static let register = baseURL + "/account/register/"
        static let findPassword = baseURL + "/account/findpw/"
        static let editProfile = baseURL + "/account/edit1/"
        static let changePassword = baseURL + "/account/edit2/"
        static let withdrawal = baseURL + "/account/withdrawal/"
        static let checkToken = baseURL + "/account/cktoken/"
    }
    
    enum ToDo {
        static let groupName = baseURL + "/todo/name/priority/"
    }
    
    static let getEmailCode: String = "/account/emailcode/"
    static let postEmailCode: String = "/account/emailcode/"
    static let register: String = "/account/register/"
    static let login: String = "/account/login/"
    static let todo: String = "/todo/todo/"
    static let editProfile = "/account/edit1/"
    static let priority = "/todo/color/priority/"
    static let getColor = "/todo/color/"
    static let editPassword = "/account/edit2/"
    static let category = "/todo/name/priority/"
    static let who = "/account/who/"
    static let day = "/todo/day/"
    
    enum Friend {
        static let searchRequest: String = "/account/find_req_friend/"
        static let requestFriend: String = "/account/add_friend/"
        static let searchFriend: String = "/account/my_friends/"
        static let handleRequest: String = "/account/check_req_friend/"
        static let updateStar: String = "/account/update_star/"
        static let deleteFriend: String = "/account/del_friend/"
        static let searchTodo: String = "/todo/todo_friend/"
        static let day: String = "/todo/day_friend/"
        static let category = "/todo/name/priority/"
    }
}
