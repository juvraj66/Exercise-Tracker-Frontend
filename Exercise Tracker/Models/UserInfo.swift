//
//  UserInfo.swift
//  Exercise Tracker
//
//  Created by Juvraj on 12/11/21.
//

import Foundation
struct UserInfo:Codable{
    var id:Int
    var userName:String
    var email:String
    var firstName:String
    var lastName:String
    
    enum CodingKeys: String, CodingKey{
        case id
        case userName = "username"
        case email
        case firstName = "first_name"
        case lastName = "last_name"
    }
    init(from decoder:Decoder)throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try valueContainer.decode(Int.self, forKey: CodingKeys.id)
        self.userName = try valueContainer.decode(String.self,forKey:CodingKeys.userName)
        self.email = try valueContainer.decode(String.self,forKey:CodingKeys.email)
        self.firstName = try valueContainer.decode(String.self,forKey:CodingKeys.firstName)
        self.lastName = try valueContainer.decode(String.self,forKey:CodingKeys.lastName)
    }
}
