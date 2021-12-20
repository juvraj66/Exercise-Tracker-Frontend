//
//  UserExerciseInfo.swift
//  Exercise Tracker
//
//  Created by Juvraj on 12/1/21.
//

import Foundation
struct UserExerciseInfo: Codable {
    var userID:Int
    var entryID:Int
    var exercise: String
    var exerciseID:Int
    var muscleGroup:String
    var weight: String
    var reps: String
    var unit:String
    var date:String
    enum CodingKeys: String, CodingKey {
        case userID = "user"
        case exercise = "exercise_name"
        case muscleGroup = "muscle_group"
        case exerciseID = "u_exercise"
        case weight
        case reps
        case entryID = "id"
        case unit
        case date = "updated_at"
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy:
        CodingKeys.self)
        self.userID = try valueContainer.decode(Int.self,forKey:CodingKeys.userID)
        self.entryID = try valueContainer.decode(Int.self,forKey: CodingKeys.entryID)
        self.exercise = try valueContainer.decode(String.self,
        forKey: CodingKeys.exercise)
        self.exerciseID = try valueContainer.decode(Int.self,forKey: CodingKeys.exerciseID)
        self.muscleGroup = try valueContainer.decode(String.self,forKey:CodingKeys.muscleGroup)
        self.weight = try valueContainer.decode(String.self,
        forKey: CodingKeys.weight)
        self.reps = try valueContainer.decode(String.self, forKey:
        CodingKeys.reps)
        self.unit = try valueContainer.decode(String.self, forKey:CodingKeys.unit)
        self.date = try valueContainer.decode(String.self, forKey:CodingKeys.date)
    }
}
