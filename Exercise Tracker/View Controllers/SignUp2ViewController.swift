//
//  SignUp2ViewController.swift
//  Exercise Tracker
//
//  Created by Juvraj on 12/8/21.
//

import UIKit

class SignUp2ViewController: UIViewController {

    var firstName = String()
    var lastName = String()
    @IBOutlet weak private var userNameTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var password1TextField: UITextField!
    @IBOutlet weak private var password2TextField: UITextField!
    @IBOutlet weak private var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let userNameText = userNameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty
        let emailText = emailTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty
        let password1Text = password1TextField.text?.trimmingCharacters(in: .whitespaces).isEmpty
        let password2Text = password2TextField.text?.trimmingCharacters(in: .whitespaces).isEmpty
        
        if firstName == "" || lastName == "" || userNameText==true || emailText==true || password1Text==true || password2Text==true {
            errorLabel.text = "Fields cannot not be blank."
        }
        else if validateEmail(enteredEmail: emailTextField.text!)==false{
            errorLabel.text = "Not vaild email."
        }
        else if (password1TextField.text?.count)!<8 {
            errorLabel.text = "Password too short."
        }
        else if password1TextField.text != password2TextField.text {
            errorLabel.text = "Passwords do not match."
        }
        else{
            errorLabel.text = ""
            let userName = userNameTextField.text!
            let email = emailTextField.text!
            let password1 = password1TextField.text!
            let password2 = password2TextField.text!
            
            RestAPIManager.sharedInstance.signUp(userName: userName, email:email, password1: password1, password2: password2, firstNameF: firstName, lastNameF: lastName){[weak self] err in
                if err != ""{
                    DispatchQueue.main.async {
                        self!.errorLabel.text = err
                    }
                }
                else if err==""{
                    DispatchQueue.main.async
                    {self!.performSegue(withIdentifier: "signUpComplete" , sender: nil)
                    }
                }
            }
        }
    }
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
}
