//
//  SignupType.swift
//  Live Streaming App
//
//  Created by Sudayn on 19/4/2024.
//

import Foundation

struct SignupType: Codable {
    let firstname: String
    let lastname: String
    let dob: Int
    let username: String
    let token: String
    let phone: String?
}
