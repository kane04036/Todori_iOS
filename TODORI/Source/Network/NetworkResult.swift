//
//  NetworkResult.swift
//  TODORI
//
//  Created by Dasol on 2023/05/02.
//

enum AFResult<T> {
    case success(T)
    case failure(T)
}
