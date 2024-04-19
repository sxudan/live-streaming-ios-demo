//
//  MediaResponseType.swift
//  Live Streaming App
//
//  Created by Sudayn on 19/4/2024.
//

import Foundation

struct MediaResponse: Codable {
    let success: Bool
    let data: [Media]
}

struct Media: Codable {
    let url: String
    let createdAt: Int
    let postedBy: User
}


