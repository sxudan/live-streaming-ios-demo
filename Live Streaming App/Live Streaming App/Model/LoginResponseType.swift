//
//  LoginResponseType.swift
//  Live Streaming App
//
//  Created by Sudayn on 18/4/2024.
//

import Foundation

struct Connection: Codable {
    let id: String
    let followedBy: String
    let followedTo: String
    let createdAt: Int
}

struct User: Codable {
    let uid: String
    let firstname: String
    let lastname: String
    let username: String
    let email: String
    let dob: Int
    let phone: String?
    let followers: [Connection]?
    let following: [Connection]?
}

struct LoginResponseType: Decodable {
    let success: Bool
    let user: User
    let access_token: String
}


