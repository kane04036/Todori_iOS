//
//  Todo.swift
//  TODORI
//
//  Created by Dasol on 2023/05/29.
//

import Foundation

struct ToDo {
    var year: String
    var month: String
    var day: String
    var title: String
    var done: Bool
    var isNew: Bool
    var writer: String
    var color: Int
    var id: Int
    var time: String
    var description: String
}

class GroupData {
    static let shared = GroupData() // 싱글톤 인스턴스
    
    var firstGroupName: String?
    var secondGroupName: String?
    var thirdGroupName: String?
    var fourthGroupName: String?
    var fifthGroupName: String?
    var sixthGroupName: String?
    
    private init() {}
}
