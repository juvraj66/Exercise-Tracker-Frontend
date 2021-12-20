//
//  ChangeNameViewController.swift
//  Exercise Tracker
//
//  Created by Juvraj on 12/10/21.
//

import UIKit

class ChangeNameViewController: UIViewController {
    
    @IBOutlet weak private var  firstNameTextField: UITextField!
    @IBOutlet weak private var lastNameTextField: UITextField!
    
    var firstName = ""
    var lastName = ""
    var userID = ""
    private var userToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
        userToken = RestAPIManager.sharedInstance.token
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToAccount", sender:nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        let firstNameText = firstNameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty
        let lastNameText = lastNameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty
        firstName = firstNameTextField.text!
        lastName = lastNameTextField.text!
        if firstNameText==false && lastNameText==false && userID != ""{
            RestAPIManager.sharedInstance.userChangeNamePatch(userToken:userToken, userID: userID, firstName: firstName, lastName: lastName){
            }
            performSegue(withIdentifier: "goToAccount", sender:nil)
        }
    }
}
