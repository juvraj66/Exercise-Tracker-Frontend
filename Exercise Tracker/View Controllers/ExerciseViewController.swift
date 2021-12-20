//
//  TestViewController.swift
//  Exercise Tracker
//
//  Created by Juvraj on 11/19/21.
//

import UIKit

class ExerciseViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var myTableView: UITableView!
    private var exercises = [ExerciseInfo]()
    private var exerciseName = String()
    private var exerciseID = String()
    private var filterSelected = ""
    private var userID = ""
    @IBOutlet private weak var allFilterButton: UIButton!
    @IBOutlet private weak var chestFilterButton: UIButton!
    @IBOutlet private weak var backFilterButton: UIButton!
    @IBOutlet private weak var shouldersFilterButton: UIButton!
    @IBOutlet private weak var legsFilterButton: UIButton!
    @IBOutlet private weak var armsFilterButton: UIButton!
    @IBOutlet private weak var absFilterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load user token
        let defaults = UserDefaults.standard
        if let token = defaults.value(forKey:"Token")as? String{
            print(token)
            RestAPIManager.sharedInstance.token = token
        }
        myTableView.dataSource = self
        myTableView.delegate = self
        makeRoundedButtons()
        updateTableViewUI()
        let userToken = RestAPIManager.sharedInstance.token
        RestAPIManager.sharedInstance.fetchProfile(userToken:userToken){ [weak self]
            userDic in
            if userDic.count>0{
                self!.userID = String(userDic[0].id)
            }
        }
    }
    func makeRoundedButtons(){
        allFilterButton.layer.cornerRadius = allFilterButton.frame.size.height/2
        chestFilterButton.layer.cornerRadius = chestFilterButton.frame.size.height/2
        backFilterButton.layer.cornerRadius = backFilterButton.frame.size.height/2
        shouldersFilterButton.layer.cornerRadius = shouldersFilterButton.frame.size.height/2
        legsFilterButton.layer.cornerRadius  = legsFilterButton.frame.size.height/2
        armsFilterButton.layer.cornerRadius = armsFilterButton.frame.size.height/2
        absFilterButton.layer.cornerRadius = absFilterButton.frame.size.height/2
    }
    
    func updateTableViewUI(){
        RestAPIManager.sharedInstance.fetchExercises(filterSelected:filterSelected) { [weak self] excercisesDic in
            self?.exercises = excercisesDic
            DispatchQueue.main.async{
                self?.myTableView.reloadData()
            }
        }
    }
  
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        let buttonText = sender.titleLabel!.text
        let buttonTextString = buttonText!
        updateButtonUI(buttonText: buttonTextString)
        setFilterSelected(filterName: buttonTextString)
        updateTableViewUI()
    }
    func setFilterSelected(filterName:String)->Void{
        filterSelected = filterName
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        exerciseName = exercises[indexPath.row].exercise
        exerciseID = String(exercises[indexPath.row].id)
        performSegue(withIdentifier: "addUserExercise", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "exercisesCell") as! TableViewCell
        let exercise = exercises[indexPath.row].exercise
        let muscleGroup = exercises[indexPath.row].muscleGroup
        cell.textLabel?.text = exercise
        loadImages(cell: cell, muscleGroup: muscleGroup)
        return cell
    }
    func loadImages(cell:TableViewCell,muscleGroup:String){
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
    func updateButtonUI(buttonText:String)->Void {
        if buttonText == "All"{
            allFilterButton.backgroundColor = UIColor.systemYellow
            backFilterButton.backgroundColor = UIColor.black
            chestFilterButton.backgroundColor = UIColor.black
            legsFilterButton.backgroundColor = UIColor.black
            armsFilterButton.backgroundColor = UIColor.black
            absFilterButton.backgroundColor = UIColor.black
            shouldersFilterButton.backgroundColor = UIColor.black
        }else if buttonText == "Back"{
            allFilterButton.backgroundColor = UIColor.black
            backFilterButton.backgroundColor = UIColor.systemYellow
            chestFilterButton.backgroundColor = UIColor.black
            legsFilterButton.backgroundColor = UIColor.black
            armsFilterButton.backgroundColor = UIColor.black
            absFilterButton.backgroundColor = UIColor.black
            shouldersFilterButton.backgroundColor = UIColor.black
        }else if buttonText == "Chest"{
            allFilterButton.backgroundColor = UIColor.black
            backFilterButton.backgroundColor = UIColor.black
            chestFilterButton.backgroundColor = UIColor.systemYellow
            legsFilterButton.backgroundColor = UIColor.black
            armsFilterButton.backgroundColor = UIColor.black
            absFilterButton.backgroundColor = UIColor.black
            shouldersFilterButton.backgroundColor = UIColor.black
        }else if buttonText == "Legs"{
            allFilterButton.backgroundColor = UIColor.black
            backFilterButton.backgroundColor = UIColor.black
            chestFilterButton.backgroundColor = UIColor.black
            legsFilterButton.backgroundColor = UIColor.systemYellow
            armsFilterButton.backgroundColor = UIColor.black
            absFilterButton.backgroundColor = UIColor.black
            shouldersFilterButton.backgroundColor = UIColor.black
        }else if buttonText == "Arms"{
            allFilterButton.backgroundColor = UIColor.black
            backFilterButton.backgroundColor = UIColor.black
            chestFilterButton.backgroundColor = UIColor.black
            legsFilterButton.backgroundColor = UIColor.black
            armsFilterButton.backgroundColor = UIColor.systemYellow
            absFilterButton.backgroundColor = UIColor.black
            shouldersFilterButton.backgroundColor = UIColor.black
        }else if buttonText == "Abs"{
            allFilterButton.backgroundColor = UIColor.black
            backFilterButton.backgroundColor = UIColor.black
            chestFilterButton.backgroundColor = UIColor.black
            legsFilterButton.backgroundColor = UIColor.black
            armsFilterButton.backgroundColor = UIColor.black
            absFilterButton.backgroundColor = UIColor.systemYellow
            shouldersFilterButton.backgroundColor = UIColor.black
        }else if buttonText == "Shoulders"{
            allFilterButton.backgroundColor = UIColor.black
            backFilterButton.backgroundColor = UIColor.black
            chestFilterButton.backgroundColor = UIColor.black
            legsFilterButton.backgroundColor = UIColor.black
            armsFilterButton.backgroundColor = UIColor.black
            absFilterButton.backgroundColor = UIColor.black
            shouldersFilterButton.backgroundColor = UIColor.systemYellow
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addUserExercise" {
            let secondViewController = segue.destination as! UserExercisePostViewController
            secondViewController.exerciseName = exerciseName
            secondViewController.exerciseID = exerciseID
            secondViewController.userID = userID
        }
    }
    // Search goes back to exercise
    @IBAction func unwindToExcercises(_sender:UIStoryboardSegue){
    }
   
}

