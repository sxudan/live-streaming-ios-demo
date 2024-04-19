//
//  ViewController.swift
//  Live Streaming App
//
//  Created by xkal on 5/4/2024.
//

import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import AuthenticationServices

enum AuthType {
    case Signin
    case Signup
}


class AuthViewController: UIViewController {
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var stackview: UIStackView!
    var authType: AuthType = .Signup {
        didSet {
            switch authType {
            case .Signin:
                titleLabel.text = "Login for Live Stream App"
                actionButton.setTitle("Signup", for: .normal)
                bottomLabel.text = "Don't have an account?"
                break
            case .Signup:
                titleLabel.text = "Signup for Live Stream App"
                actionButton.setTitle("Login", for: .normal)
                bottomLabel.text = "Already have an account?"
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authType = .Signup
        setupGoogleLogin()
        setupAppleLoginButton()
        errorListener()
    }
    
    func errorListener() {
        AppModel.shared.$errorMessage.sink(receiveValue: { error in
            if error != nil {
                self.showToast(message: error!)
            }
        })
    }
    
    @IBAction func actionOnPress(_ sender: Any) {
        switch authType {
        case .Signin:
            authType = .Signup
        case .Signup:
            authType = .Signin
        }
    }
  
    
    
    func setupGoogleLogin() {
        let manager = GIDSignIn.sharedInstance
        manager.configuration = GIDConfiguration(clientID: FirebaseApp.app()?.options.clientID ?? "")
        let signInButton = UIButton(type: .system)
        signInButton.setTitle("Continue with Google", for: .normal)
        signInButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        signInButton.addTarget(self, action: #selector(onGoogleLogin), for: .touchUpInside)
        self.stackview.addArrangedSubview(signInButton)
    }
    
    func setupAppleLoginButton() {
        let authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .continue, authorizationButtonStyle: .whiteOutline)
        authorizationButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        authorizationButton.addTarget(self, action: #selector(performAppleSignIn), for: .touchUpInside)
        self.stackview.addArrangedSubview(authorizationButton)
    }
 
    
    @objc func performAppleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    
    @objc func onGoogleLogin() {
        
//        return
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            let user = signInResult.user
            guard let idToken = user.idToken else {
                return
            }
            print(idToken.tokenString)
            if self.authType == .Signup {
                if let createAccountVC: CreateAccountViewController = Storyboards.instantiateViewController(from: "Main", withIdentifier: "CreateAccountViewController") {
                    createAccountVC.email = user.profile?.email
                    createAccountVC.token = idToken.tokenString
                    self.navigationController?.present(createAccountVC, animated: false)
                }
            } else {
                AppModel.shared.login(token: idToken.tokenString)
            }
            
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString)
        }
    }
    
}

extension AuthViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let token = appleIDCredential.identityToken!
            let tokenString = String(data: token, encoding: .utf8)!
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nil)
//            AppModel.shared.firebaseLogin(credential: credential)
            // Sign in with Firebase using the Apple credential
        }
    }
}


extension UIViewController {
    func showToast(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
        
        // Dismiss the alert controller after a short delay
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            alertController.dismiss(animated: true, completion: nil)
            AppModel.shared.errorMessage = nil
        }
    }
}
