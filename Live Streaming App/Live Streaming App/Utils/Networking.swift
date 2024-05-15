//
//  Networking.swift
//  Live Streaming App
//
//  Created by Sudayn on 18/4/2024.
//

import Foundation
import Alamofire

class Networking {
    
    static let base_url = "http://192.168.1.100:3000"
    
    static func POST<T: Decodable>(path: String,body: Codable?, completion: @escaping (Result<T, ErrorResponseType>) -> Void) {
        let handler: (DataResponse<T, AFError>) -> Void = { response in
            switch response.result {
            case .success(let data):
                print(data)
                // Call the completion handler with the response data
                completion(.success(data))
            case .failure(let error):
                if let resData = response.data, let decodedError = try? JSONDecoder().decode(ErrorResponse.self, from: resData) {
                    completion(.failure(decodedError.error))
                } else {
                    completion(.failure(ErrorResponseType(status: 500, code: "Error Parsing", message: error.localizedDescription)))
                }
            }
        }
        if let body = body {
            AF.request("\(base_url)\(path)", method: .post, parameters: body, encoder: JSONParameterEncoder.default).responseDecodable(of: T.self, completionHandler: handler)
        } else {
            AF.request("\(base_url)\(path)", method: .post).responseDecodable(of: T.self, completionHandler: handler)
        }
    }
    
    static func PUT<T: Decodable>(path: String,body: Codable, completion: @escaping (Result<T, ErrorResponseType>) -> Void) {
        AF.request("\(base_url)\(path)", method: .put, parameters: body, encoder: JSONParameterEncoder.default).responseDecodable(of: T.self) {
            response in
            switch response.result {
            case .success(let data):
                print(data)
                // Call the completion handler with the response data
                completion(.success(data))
            case .failure(let error):
                if let decodedError = try? JSONDecoder().decode(ErrorResponse.self, from: response.data!) {
                    completion(.failure(decodedError.error))
                } else {
                    completion(.failure(ErrorResponseType(status: 500, code: "Error Parsing", message: error.localizedDescription)))
                }
            }
        }
    }
    
    static func GET<T: Decodable>(path: String, completion: @escaping (Result<T, ErrorResponseType>) -> Void) {
        AF.request("\(base_url)\(path)", method: .get).responseDecodable(of: T.self) {
            response in
            switch response.result {
            case .success(let data):
                print(data)
                // Call the completion handler with the response data
                completion(.success(data))
            case .failure(let error):
                if let d = response.data, let decodedError = try? JSONDecoder().decode(ErrorResponse.self, from: d ) {
                    completion(.failure(decodedError.error))
                } else {
                    completion(.failure(ErrorResponseType(status: 500, code: "Error Parsing", message: error.localizedDescription)))
                }
            }
        }
    }
}
