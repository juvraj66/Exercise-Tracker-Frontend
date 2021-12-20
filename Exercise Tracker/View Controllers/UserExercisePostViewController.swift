//
//  UserExercisePostViewController.swift
//  Exercise Tracker
//
//  Created by Juvraj on 11/22/21.
//

import UIKit

class UserExercisePostViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    private let units = ["lbs","kg"]
    private var unit = "lbs"
    var exerciseName = String()
    var exerciseID = String()
    var userID = String()
    
    @IBOutlet weak private var unitPickerView: UIPickerView!
    @IBOutlet weak private var weightTextField: UITextField!{
        didSet { weightTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet weak private var repsTextField: UITextField!{
        didSet { repsTextField?.addDoneCancelToolbar() }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = exerciseName
        unitPickerView.dataSource = self
        unitPickerView.delegate = self
    }
  
    @IBAction func done(_ sender: Any) {
        let weight = weightTextField.text!
        let reps = repsTextField.text!
        print(weight," " ,reps," ",unit)
        let token = RestAPIManager.sharedInstance.token

        if weight != "" && reps != "" && unit != "" && userID != ""{
            RestAPIManager.sharedInstance.userExercisePostRequest(weight: weight,uExerciseID: exerciseID, unit: unit, reps: reps,userID: userID,userToken:token){
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "unwindExercises", sender: nil)
                }
            }
        }
        else {
            print("error")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        units.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return units[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        unit = units[row] as String
    }
}
