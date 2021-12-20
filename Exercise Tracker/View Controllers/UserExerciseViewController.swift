//
//  UserExerciseViewController.swift
//  Exercise Tracker
//
//  Created by Juvraj on 11/19/21.
//

import UIKit

class UserExerciseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet private weak var userExerciseTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    private let dateFormatterGet = DateFormatter()
    private let dateFormatterPrint = DateFormatter()
    private var userExercises = [UserExerciseInfo]()
    private var exerciseToUpdate:UserExerciseInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userExerciseTableView.dataSource = self
        userExerciseTableView.delegate = self
        searchBar.delegate = self
        searchBar.searchTextField.textColor = UIColor.white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUserExerciseTableViewUI(searchParameter: "")
    }
    func updateUserExerciseTableViewUI(searchParameter:String){
        let token = RestAPIManager.sharedInstance.token
        RestAPIManager.sharedInstance.fetchUserExercises(searchParameter:searchParameter,userToken:token){ [weak self]userExercisesDic in
            self?.userExercises = userExercisesDic
            DispatchQueue.main.async {
                self?.userExerciseTableView.reloadData()
            }
        }
    }
    
    func dateFormat(dateString:String)->String{
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatterPrint.dateFormat = "MM-dd-yyyy"
        if let date = dateFormatterGet.date(from: dateString) {
            let dateFormatted = dateFormatterPrint.string(from: date)
            return dateFormatted
        } else {
           print("There was an error decoding the string")
        }
        return ""
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateUserExerciseTableViewUI(searchParameter: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userExercises.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        exerciseToUpdate = userExercises[indexPath.row]
        performSegue(withIdentifier: "updateExercise", sender: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                   print(indexPath.row,"Deleted")
            let userExerciseDelete = userExercises[indexPath.row].entryID
            let token = RestAPIManager.sharedInstance.token

            RestAPIManager.sharedInstance.deleteUserExercise(entryID:userExerciseDelete,userToken:token)
            userExercises.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.userExerciseTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userExerciseTableView.dequeueReusableCell(withIdentifier: "userExercises") as! UserTableViewCell
        let exerciseName = userExercises[indexPath.row].exercise
        let weight = userExercises[indexPath.row].weight
        let muscleGroup = userExercises[indexPath.row].muscleGroup
        let reps = userExercises[indexPath.row].reps
        let unit = userExercises[indexPath.row].unit
        let date = userExercises[indexPath.row].date
        cell.exerciseNameLabel.text = exerciseName
        cell.weightLabel.text = "Weight:\(weight)\(unit)"
        cell.repsLabel.text = "Reps:\(reps)"
        cell.dateLabel.text = dateFormat(dateString: date)
        loadImages(cell:cell , muscleGroup: muscleGroup)
        return cell
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateExercise" {
            let nav = segue.destination as! UINavigationController
            let updateUserViewController = nav.topViewController as! UpdateUserExerciseViewController
            updateUserViewController.exerciseToUpdate = exerciseToUpdate
        }
    }
    @IBAction func unwindToUserExercise(_sender:UIStoryboardSegue){
    }
    
    func loadImages(cell:UserTableViewCell,muscleGroup:String){
        if muscleGroup=="Arms"{
            cell.myImageView!.image = UIImage(named: "arm")
        }else if muscleGroup=="Shoulders"{
            cell.myImageView!.image = UIImage(named: "shoulder")
        }else if muscleGroup=="Back"{
            cell.myImageView!.image = UIImage(named: "back")
        }else if muscleGroup=="Abs"{
            cell.myImageView!.image = UIImage(named: "abs")
        }else if muscleGroup=="Legs"{
            cell.myImageView!.image = UIImage(named: "legs")
        }else if muscleGroup=="Chest"{
            cell.myImageView!.image = UIImage(named: "chest")
        }
    }

}
