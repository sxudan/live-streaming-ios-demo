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
        let uid = currentUser?.uid ?? ""
        Networking.GET(path: "/medias?uid=\(uid)", completion: response)
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
    
    func createMediaPost(completion: @escaping (Media) -> Void) {
        let response: (Result<CreateMediaResponse, ErrorResponseType>) -> Void = { res in
            switch res {
            case .success(let media):
                completion(media.data)
                break
            case .failure(let error):
                self.errorMessage = error.message
                break
            }
        }
        Networking.POST(path: "/medias", body: CreateMediaInput(uid: currentUser!.uid), completion: response)
    }
    
    func updateMediaPost(mediaId: String, type: MediaUpdateType, completion: @escaping (Media) -> Void) {
        let response: (Result<CreateMediaResponse, ErrorResponseType>) -> Void = { res in
            switch res {
            case .success(let media):
                completion(media.data)
                break
            case .failure(let error):
                self.errorMessage = error.message
                break
            }
        }
        print("Updating media \(mediaId)")
        Networking.PUT(path: "/medias", body: UpdateMediaInput(uid: currentUser!.uid, streamId: mediaId, status: type), completion: response)
    }
    
    func searchProfile(query: String, completion: @escaping ([User]) -> Void) {
        let response: (Result<SearchProfileResponse, ErrorResponseType>) -> Void = { res in
            switch res {
            case .success(let data):
                completion(data.data)
                break
            case .failure(let error):
                self.errorMessage = error.message
                break
            }
        }
        Networking.GET(path: "/profile?search=\(query)", completion: response)
    }
    
    func getProfile(id: String, completion: @escaping (User) -> Void) {
        let response: (Result<ProfileResponse, ErrorResponseType>) -> Void = { res in
            switch res {
            case .success(let data):
                completion(data.data)
                break
            case .failure(let error):
                self.errorMessage = error.message
                break
            }
        }
        Networking.GET(path: "/profile/\(id)", completion: response)
    }
    
    func followProfile(uid: String,to: String, completion: @escaping () -> Void) {
        let response: (Result<NormalResponse, ErrorResponseType>) -> Void = { res in
            switch res {
            case .success(let data):
                completion()
                break
            case .failure(let error):
                self.errorMessage = error.message
                break
            }
        }
        Networking.POST(path: "/profile/\(uid)/follow/\(to)", body: nil, completion: response)
    }
    
    func unfollowProfile(uid: String,to: String, completion: @escaping () -> Void) {
        let response: (Result<NormalResponse, ErrorResponseType>) -> Void = { res in
            switch res {
            case .success(let data):
                completion()
                break
            case .failure(let error):
                self.errorMessage = error.message
                break
            }
        }
        Networking.POST(path: "/profile/\(uid)/unfollow/\(to)",body: nil, completion: response)
    }
    
    func getComments(streamId: String, completion: @escaping ([Comment], _ count: Int) -> Void) {
        let response: (Result<CommentFetchResponse, ErrorResponseType>) -> Void = { res in
            switch res {
            case .success(let data):
                completion(data.data, data.viewCount)
                break
            case .failure(let error):
                self.errorMessage = error.message
                break
            }
        }
        Networking.GET(path: "/medias/\(streamId)/comment", completion: response)
    }
    
    func postComment(streamId: String,body: CommentInput, completion: @escaping () -> Void) {
        let response: (Result<NormalResponse, ErrorResponseType>) -> Void = { res in
            switch res {
            case .success(let data):
                completion()
                break
            case .failure(let error):
                self.errorMessage = error.message
                break
            }
        }
        Networking.POST(path: "/medias/\(streamId)/comment",body: body, completion: response)
    }
    
    func increaseViewCount(streamId: String, completion: @escaping () -> Void) {
        let response: (Result<NormalResponse, ErrorResponseType>) -> Void = { res in
            switch res {
            case .success(let media):
                completion()
                break
            case .failure(let error):
                self.errorMessage = error.message
                break
            }
        }
        Networking.POST(path: "/medias/viewcount/increase", body: StreamInput(streamId: streamId), completion: response)
    }
    
    func decreaseViewCount(streamId: String, completion: @escaping () -> Void) {
        let response: (Result<NormalResponse, ErrorResponseType>) -> Void = { res in
            switch res {
            case .success(let media):
                completion()
                break
            case .failure(let error):
                self.errorMessage = error.message
                break
            }
        }
        Networking.POST(path: "/medias/viewcount/decrease", body: StreamInput(streamId: streamId), completion: response)
    }
    
    func logout() {
        self.authState = .NotLoggedIn
    }
    
}
