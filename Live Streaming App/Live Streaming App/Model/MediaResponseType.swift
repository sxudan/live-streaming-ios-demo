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

enum MediaUpdateType: String, Codable {
    case Publishing = "PUBLISHING"
    case Stopped = "STOPPED"
}

struct Media: Codable {
    let streamId: String
    let url: String
    let createdAt: Int
    let postedBy: User
}

struct CreateMediaInput: Codable {
    let uid: String
}

struct UpdateMediaInput: Codable {
    let uid: String
    let streamId: String
    let status: MediaUpdateType
}

struct CreateMediaResponse: Codable {
    let success: Bool
    let data: Media
}
