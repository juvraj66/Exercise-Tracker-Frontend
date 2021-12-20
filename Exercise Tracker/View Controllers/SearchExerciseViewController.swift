//
//  SearchExerciseViewController.swift
//  Exercise Tracker
//
//  Created by Juvraj on 11/29/21.
//

import UIKit

class SearchExerciseViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private var exercises = [ExerciseInfo]()
    private var exerciseName = String()
    private var exerciseID = String()
    private var userID = ""
    @IBOutlet private weak var searchExerciseTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchExerciseTableView.dataSource = self
        searchExerciseTableView.delegate = self
        searchBar.delegate = self
        searchBar.searchTextField.textColor = UIColor.white
        let userToken = RestAPIManager.sharedInstance.token
        RestAPIManager.sharedInstance.fetchProfile(userToken:userToken){ [weak self]
            userDic in
            if userDic.count>0{
                self!.userID = String(userDic[0].id)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        RestAPIManager.sharedInstance.fetchExercisesSearch(searchParameter:searchText) { [weak self] excercisesDic in
            self?.exercises = excercisesDic
            DispatchQueue.main.async{
                self?.searchExerciseTableView.reloadData()
            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exercises.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        exerciseName = exercises[indexPath.row].exercise
        exerciseID = String(exercises[indexPath.row].id)
        performSegue(withIdentifier: "addExercise2", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchExerciseTableView.dequeueReusableCell(withIdentifier: "searchExercise") as! SearchExerciseTableViewCell
        let exercise = exercises[indexPath.row].exercise
        let muscleGroup = exercises[indexPath.row].muscleGroup
        cell.textLabel?.text = exercise
        loadImages(cell: cell, muscleGroup: muscleGroup)
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addExercise2" {
            let secondViewController = segue.destination as! UserExercisePostViewController
            secondViewController.exerciseName = exerciseName
            secondViewController.exerciseID = exerciseID
            secondViewController.userID = userID
        }
    }
    func loadImages(cell:SearchExerciseTableViewCell,muscleGroup:String){
        if muscleGroup=="Arms"{
            cell.imageView!.image = UIImage(named: "arm")
        }
        else if muscleGroup=="Shoulders"{
            cell.imageView!.image = UIImage(named: "shoulder")
        }
        else if muscleGroup=="Back"{
            cell.imageView!.image = UIImage(named: "back")
        }
        else if muscleGroup=="Abs"{
            cell.imageView!.image = UIImage(named: "abs")
        }
        else if muscleGroup=="Legs"{
            cell.imageView!.image = UIImage(named: "legs")
        }
        else if muscleGroup=="Chest"{
            cell.imageView!.image = UIImage(named: "chest")
        }
    }
}
