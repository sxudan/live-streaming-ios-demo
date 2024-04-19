//
//  ProfileType.swift
//  Live Streaming App
//
//  Created by Sudayn on 19/4/2024.
//

import Foundation

struct UpdateProfileInput: Codable {
    let uid: String
    let firstname: String
    let lastname: String
    let dob: Int
    let phone: String?
}

struct UpdateProfileResponse: Codable {
    let success: Bool
    let data: User
}
