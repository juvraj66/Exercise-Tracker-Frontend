//
//  UpdateUserExerciseViewController.swift
//  Exercise Tracker
//
//  Created by Juvraj on 12/2/21.
//

import UIKit

class UpdateUserExerciseViewController: UIViewController, UIPickerViewDataSource
, UIPickerViewDelegate{
    private var units = ["lbs","kg"]
    private var unit = "lbs"
    var exerciseToUpdate:UserExerciseInfo?

    @IBOutlet weak private var unitPickerView: UIPickerView!
    @IBOutlet weak private var weightTextField: UITextField!{
        didSet { weightTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet weak private var repsTextField: UITextField!{
        didSet { repsTextField?.addDoneCancelToolbar() }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        unitPickerView.dataSource = self
        unitPickerView.delegate = self
        self.title = exerciseToUpdate?.exercise
        weightTextField.text = exerciseToUpdate?.weight
        repsTextField.text = exerciseToUpdate?.reps
        unit = exerciseToUpdate?.unit ?? "lbs"
        if unit == "kg"{
            units[0] = "kg"
            units[1] = "lbs"
        }
    }
    @IBAction func cancelButtonPressed( _ sender:Any){
        performSegue(withIdentifier: "goBackToUserExercises", sender:nil)
    }
    
    @IBAction func doneButtonPressed(_ sender:Any){
        let exericseToUpdateUnwrapped = exerciseToUpdate!
        let userID = String(exericseToUpdateUnwrapped.userID)
        let exerciseID = String(exericseToUpdateUnwrapped.exerciseID)
        let entryID = String(exericseToUpdateUnwrapped.entryID)
        let weight = weightTextField.text!
        let reps = repsTextField.text!
        let unit0 = unit
        let token = RestAPIManager.sharedInstance.token
        if  entryID != "" && exerciseID != "" && weight != "" && reps != "" && unit0 != ""{
            RestAPIManager.sharedInstance.updateUserExercisePut(entryID: entryID, weight: weight, unit0: unit0, reps: reps, userID:userID, exerciseID: exerciseID,userToken:token){
                DispatchQueue.main.async{
                    self.performSegue(withIdentifier: "goBackToUserExercises", sender: nil)
                }
            }
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
