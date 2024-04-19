//
//  CreateAccountViewController.swift
//  Live Streaming App
//
//  Created by Sudayn on 18/4/2024.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    
    var token: String?
    var email: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let email = email, let token = token {
            emailLabel.text = email
        } else {
            self.navigationController?.dismiss(animated: true)
        }
    }
    
    @IBAction func onCreateAccount(_ sender: Any) {
        if let token = token {
            AppModel.shared.signup(token: token, firstname: firstnameTextField.text ?? "", lastname: lastnameTextField.text ?? "", username: usernameTextField.text ?? "", dob: 10000, phone: phoneTextField.text ?? "")
            self.dismiss(animated: true)
        }
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
        
    }
    
}
