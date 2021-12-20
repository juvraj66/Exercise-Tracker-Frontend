//
//  SignInViewController.swift
//  Exercise Tracker
//
//  Created by Juvraj on 11/9/21.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak private var userNameTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func signInAction(_ sender: Any) {
        let userNameText = userNameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty
        let passwordText = passwordTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty
        
        if userNameText==true || passwordText==true{
            print("Fields cant not be black")
            errorLabel.text = "Fields can not be blank."
        }
        else {
            let userName = userNameTextField.text!
            let password = passwordTextField.text!
            RestAPIManager.sharedInstance.signIn(userName: userName, password: password){ [weak self] err in
                if err != ""{
                    DispatchQueue.main.async {
                        self!.errorLabel.text = err
                    }
                }
                else if err==""{
                    DispatchQueue.main.async {
                        self!.performSegue(withIdentifier: "signIn", sender: nil)
                    }
                }
            }
        }
    }
}
