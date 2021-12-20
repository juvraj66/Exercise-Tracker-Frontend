//
//  ChangePasswordViewController.swift
//  Exercise Tracker
//
//  Created by Juvraj on 12/13/21.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet private weak var password1TextField: UITextField!
    @IBOutlet private weak var  password2TextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    private var userToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userToken = RestAPIManager.sharedInstance.token
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        let password1IsEmpty = password1TextField.text?.trimmingCharacters(in: .whitespaces).isEmpty
        let password2IsEmpty = password2TextField.text?.trimmingCharacters(in: .whitespaces).isEmpty
        let password1Text = password1TextField.text
        let password2Text = password2TextField.text
        if password1IsEmpty==true || password2IsEmpty==true{
            errorLabel.text = "Fields cannot be empty."
        }
        else if password1Text!.count<8{
            errorLabel.text = "Password must be 8 characters or more."
        }
        else if password1Text != password2Text{
            errorLabel.text = "Passwords do not match."
        }
        else{
            print(password1Text!)
            RestAPIManager.sharedInstance.changeUserPassword(password1: password1Text!, password2: password2Text!, userToken: userToken){ err in
                if err != ""{
                    DispatchQueue.main.async{
                        self.errorLabel.text = err
                    }
                }
                else{
                    DispatchQueue.main.async{
                        self.performSegue(withIdentifier: "goToAccount1", sender: nil)
                    }
                }
            }
        }
    }
}
