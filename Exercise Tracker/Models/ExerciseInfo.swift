//
//  ExerciseInfo.swift
//  Exercise Tracker
//
//  Created by Juvraj on 11/18/21.
//

import Foundation
struct ExerciseInfo: Codable {
    var id:Int
    var exercise: String
    var muscleGroup: String
    var equipment: String
    enum CodingKeys: String, CodingKey {
        case exercise = "exercise_name"
        case muscleGroup="muscle_group"
        case equipment
        case id
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy:
        CodingKeys.self)
        self.id = try valueContainer.decode(Int.self,forKey: CodingKeys.id)
        self.exercise = try valueContainer.decode(String.self,
        forKey: CodingKeys.exercise)
        self.muscleGroup = try valueContainer.decode(String.self,
        forKey: CodingKeys.muscleGroup)
        self.equipment = try valueContainer.decode(String.self, forKey:
        CodingKeys.equipment)
    }
}
