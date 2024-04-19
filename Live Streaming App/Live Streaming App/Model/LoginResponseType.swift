//
//  LoginResponseType.swift
//  Live Streaming App
//
//  Created by Sudayn on 18/4/2024.
//

import Foundation

struct User: Codable {
    let uid: String
    let firstname: String
    let lastname: String
    let username: String
    let email: String
    let dob: Int
    let phone: String?
}

struct LoginResponseType: Decodable {
    let success: Bool
    let user: User
    let access_token: String
}


