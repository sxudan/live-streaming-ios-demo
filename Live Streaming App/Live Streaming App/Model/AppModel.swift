//
//  AppModel.swift
//  Live Streaming App
//
//  Created by Sudayn on 5/4/2024.
//

import Foundation
import GoogleSignIn

import AuthenticationServices
import Combine


enum AuthState {
    case LoggedIn(accessToken: String, user: User)
    case NotLoggedIn
    case Loading
}

enum AuthProviderType: String {
    case Apple = "apple"
    case Google = "google"
}


class AppModel {
    
    public static let shared = AppModel()
    
    
    var isLoggedIn: Bool {
        get {
            return currentUser != nil
        }
    }
    
    var currentUser: User?
    var accessToken: String?
    
    @Published var errorMessage: String?
    
    @Published var authState: AuthState = .Loading {
        willSet {
            switch newValue {
            case .LoggedIn(let token, let user):
                CredentialHelper.saveAccessToken(token: token)
                currentUser = user
                accessToken = token
                break
            case .NotLoggedIn:
                CredentialHelper.clearAccessToken()
                break
            case .Loading:
                return
            }
        }
    }
    
    private init() {
        self.authState = .Loading
     
        guard let currentUser = currentUser else {
            guard let savedToken = CredentialHelper.retrieveAccessToken() else {
                self.authState = .NotLoggedIn
                return
            }
            login(token: savedToken)
            return
        }
    }
 
    func login(token: String) {
        self.authState = .Loading
        let response: (Result<LoginResponseType, ErrorResponseType>) -> Void = { res in
            switch res {
            case .success(let loginData):
                self.authState = .LoggedIn(accessToken: loginData.access_token, user: loginData.user)
                break
            case .failure(let error):
                self.logout()
                print(error)
                self.errorMessage = error.message
                break
            }
        }
        Networking.POST(path: "/auth/login", body: LoginType(token: token), completion: response)
    }
    
    func signup(token: String, firstname: String, lastname: String, username: String, dob: Int, phone: String?) {
        self.authState = .Loading
        let response: (Result<LoginResponseType, ErrorResponseType>) -> Void = { res in
            switch res {
            case .success(let loginData):
                self.authState = .LoggedIn(accessToken: loginData.access_token, user: loginData.user)
                break
            case .failure(let error):
                self.logout()
                print(error)
                self.errorMessage = error.message
                break
            }
        }
        Networking.POST(path: "/auth/signup", body: SignupType(firstname: firstname, lastname: lastname, dob: dob, username: username, token: token, phone: phone), completion: response)
    }
    
    func fetchAllVideos(completion: @escaping ([Media]) -> Void, errorHandler: @escaping (Error) -> Void) {
        let response: (Result<MediaResponse, ErrorResponseType>) -> Void = { res in
            switch res {
            case .success(let res):
                completion(res.data)
                break
            case .failure(let error):
                errorHandler(error)
                break
            }
        }
        Networking.GET(path: "/medias", completion: response)
    }
    
    func updateProfile(data: UpdateProfileInput, completion: @escaping (User) -> Void) {
        let response: (Result<UpdateProfileResponse, ErrorResponseType>) -> Void = { res in
            switch res {
            case .success(let user):
                self.currentUser = user.data
                completion(user.data)
                break
            case .failure(let error):
                self.errorMessage = error.message
                break
            }
        }
        Networking.PUT(path: "/profile", body: data, completion: response)
    }
    
    func logout() {
        self.authState = .NotLoggedIn
    }
    
}