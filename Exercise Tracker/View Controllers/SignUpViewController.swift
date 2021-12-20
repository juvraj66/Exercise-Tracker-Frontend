//
//  SignUpViewController.swift
//  Exercise Tracker
//
//  Created by Juvraj on 12/7/21.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak private var firstNameTextField: UITextField!
    @IBOutlet weak private var lastNameTextField: UITextField!
    @IBOutlet weak private var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        let firstNameText = firstNameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty
        let lastNameText = lastNameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty
        if firstNameText == true || lastNameText==true{
            errorLabel.text = "Fields cannot not be empty."
        }
        else {
            errorLabel.text = ""
            performSegue(withIdentifier: "signUp2", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUp2" {
            let nav = segue.destination as! UINavigationController
            let SignUp2ViewController = nav.topViewController as! SignUp2ViewController
            SignUp2ViewController.firstName = firstNameTextField.text ?? ""
            SignUp2ViewController.lastName = lastNameTextField.text ?? ""
        }
    }
    
    @IBAction func unwindToSignUp1(sender:UIStoryboardSegue){
    }
}
