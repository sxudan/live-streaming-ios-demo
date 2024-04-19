//
//  ErrorResponseType.swift
//  Live Streaming App
//
//  Created by Sudayn on 19/4/2024.
//

import Foundation

struct ErrorResponse: Codable {
    let error: ErrorResponseType
}

struct ErrorResponseType: Codable, Error {
    
    let status: Int
    let code: String
    let message: String
    
}
