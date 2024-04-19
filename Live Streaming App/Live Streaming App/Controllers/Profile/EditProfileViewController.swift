//
//  EditProfileViewController.swift
//  Live Streaming App
//
//  Created by Sudayn on 19/4/2024.
//

import UIKit

class EditProfileViewController: UIViewController {

    
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialise()

    }
    
    func initialise() {
        if let profiledata = AppModel.shared.currentUser {
            firstnameTextField.text = profiledata.firstname
            lastnameTextField.text = profiledata.lastname
            emailTextField.text = profiledata.email
            dobTextField.text = profiledata.dob.toDate(format: "yyyy-MM-dd")
            phoneTextField.text = profiledata.phone
        }
    }

    @IBAction func onSave(_ sender: Any) {
        if let profiledata = AppModel.shared.currentUser {
            AppModel.shared.updateProfile(data: UpdateProfileInput(uid: profiledata.uid, firstname: firstnameTextField.text ?? "", lastname: lastnameTextField.text ?? "", dob: 4040404040, phone: phoneTextField.text), completion: { user in
                self.showToast(message: "Profile updated successfully")
                
            })
        }
        
    }
}

extension Int {
    func toDate(format: String) -> String {
        let timeInterval: TimeInterval = TimeInterval(self)
        let date = Date(timeIntervalSince1970: timeInterval)

        // Create a DateFormatter to format the Date object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format // Specify your desired date format

        // Format the Date object as a string
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
}
