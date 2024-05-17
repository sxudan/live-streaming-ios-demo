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
    let status: MediaUpdateType
    let viewCount: Int
}

struct CreateMediaInput: Codable {
    let uid: String
}

struct StreamInput: Codable {
    let streamId: String
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

struct Comment: Codable {
    let id: String
    let postedBy: User
    let comment: String
    let createdAt: Int
}

struct CommentFetchResponse: Codable {
    let success: Bool
    let data: [Comment]
    let viewCount: Int
}

struct CommentInput: Codable {
    let uid: String
    let comment: String
}

