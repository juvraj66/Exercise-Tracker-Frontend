//
//  AccountTableViewController.swift
//  Exercise Tracker
//
//  Created by Juvraj on 12/10/21.
//

import UIKit

class AccountTableViewController: UITableViewController {
    private var firstName = ""
    private var lastName = ""
    private var userID = ""
    private var userToken = ""
    var userProfile = [UserInfo]()
    // If fetch profile returns no data then make user not be able to change profile info.
    override func viewDidLoad() {
        super.viewDidLoad()
        userToken = RestAPIManager.sharedInstance.token
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        RestAPIManager.sharedInstance.fetchProfile(userToken: userToken){ [weak self] userDic in
            if userDic.count>0{
                self!.userProfile = userDic
                self!.firstName = userDic[0].firstName
                self?.lastName = userDic[0].lastName
                let uID = String(userDic[0].id)
                self?.userID = uID
            }
        }
    }

    @IBAction func deleteButtonPressed(_ sender: Any) {
        showDeleteAccountAlert()
    }
  
    @IBAction func logOutButtonPressed(_ sender: Any) {
        showLogOutAlert()
    }
    func showLogOutAlert(){
        let alert = UIAlertController(title:"Log Out",message:"",preferredStyle:.alert)
        alert.addAction(UIAlertAction(title:"Cancel",style: .cancel,handler:{ action in
        }))
        
        alert.addAction(UIAlertAction(title:"Log Out",style:.destructive,handler:{ [self]
            action in
            if self.userID != ""{
                RestAPIManager.sharedInstance.logOutUser(userToken:userToken){ err in
                    if err==false{
                        deleteToken()
                        DispatchQueue.main.async{
                            self.performSegue(withIdentifier: "goToLogin", sender: nil)
                        }
                       
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
    func deleteToken(){
        let defaults = UserDefaults.standard
        defaults.setValue(nil, forKey:"Token")
    }
    
    func showDeleteAccountAlert(){
        let alert = UIAlertController(title: "Delete Account", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Cancel",style: .cancel, handler:{ action in
            print("dismiss")
        }))
        
        alert.addAction(UIAlertAction(title:"Delete",style: .destructive, handler:{ action in
            print("Delete acc")
            if self.userID != "" {
                RestAPIManager.sharedInstance.deleteUserAccount(userID:self.userID , userToken: self.userToken ){
                    self.deleteToken()
                    DispatchQueue.main.async{
                        self.performSegue(withIdentifier: "goToLogin", sender: nil)
                    }
                }
            }
        }))
        present(alert, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == 0{ // Change name
            performSegue(withIdentifier: "changeName", sender: nil)
        }
        else if indexPath.row==1{
            performSegue(withIdentifier: "changePassword", sender:nil)
        }
    }
    
    @IBAction func unwindToAccount(sender:UIStoryboardSegue){
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="changeName"{
            let nav = segue.destination as! UINavigationController
            let ChangeNameViewContoller = nav.topViewController as! ChangeNameViewController
            ChangeNameViewContoller.firstName = firstName
            ChangeNameViewContoller.lastName = lastName
            ChangeNameViewContoller.userID = userID
        }
    }
}
