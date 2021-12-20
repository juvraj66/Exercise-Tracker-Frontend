//
//  RestApiManager.swift
//  Exercise Tracker
//
//  Created by Juvraj on 12/7/21.
//

import Foundation

class RestAPIManager{
    static let sharedInstance = RestAPIManager()
    private let baseURL = "http://django-env.eba-2s7k22x5.us-west-2.elasticbeanstalk.com/api/v1"
    var token = ""
    func signUp(userName:String,email:String,password1:String,password2:String,firstNameF:String,lastNameF:String,completion:@escaping(String)->Void){
        print("sign up")
        var err = ""
        let credentials = [
            "username": userName,
            "email":email,
            "password1":password1,
            "password2":password2,
            "first_name":firstNameF,
            "last_name":lastNameF
        ]
        let url = URL(string:"\(baseURL)/signup/")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(credentials)
        let JsonDecoder = JSONDecoder()
        let task = URLSession.shared.dataTask(with:urlRequest){ (data, response,error) in
            if let data = data {
                let response1 = response as? HTTPURLResponse
                let statusCode = Int(response1?.statusCode ?? 0)
                //print(statusCode)
                if statusCode==400{
                    var dic = try? JsonDecoder.decode([String:[String]].self, from: data)
                    dic = dic ?? ["":[""]]
                    err = dic![dic!.first!.key]![0]
                    completion(err)
                }
                else if statusCode==201{
                    let tokenDic = try? JsonDecoder.decode([String:String].self, from: data)
                    let tokenValue = String(tokenDic?["key"] ?? "None")
                    //print(tokenValue)
                    if tokenValue != "None"{
                        print(tokenValue)
                    }
                    err = ""
                    completion(err)
                }
                else {
                    err = "Error"
                    completion(err)
                }
            }
        }
        task.resume()
    }
    func signIn(userName:String,password:String,completion:@escaping(String)->Void){
        var err = ""
        let cred = ["username":userName,"password":password]
        let url = URL(string:"\(baseURL)/login/")!
        var urlRequest = URLRequest(url:url)
        urlRequest.httpMethod = "POST"
        urlRequest
            .addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(cred)
        let JsonDecoder = JSONDecoder()

        let task = URLSession.shared.dataTask(with:urlRequest){
            (data,response, error) in
            if let data = data {
                let response1 = response as? HTTPURLResponse
                let statusCode = Int(response1?.statusCode ?? 0)
                print(statusCode)
                if statusCode == 400{
                    err = "Incorrect Username or password."
                    completion(err)
                }
                else if statusCode == 200{
                    err = ""
                    let dic = try? JsonDecoder.decode([String:String].self, from: data)
                    let tokenValue = String(dic?["key"] ?? "None")
                    if tokenValue != "None"{
                        //print(tokenValue)
                        let defaults = UserDefaults.standard
                        defaults.setValue(tokenValue, forKey:"Token")
                        RestAPIManager.sharedInstance.token = tokenValue
                    }
                    completion(err)
                }
                else {
                    err = "Error"
                    completion(err)
                }
            }
        }
        task.resume()
    }
    func logOutUser(userToken:String,completion:@escaping(Bool)->Void){
        var err = false
        let url = URL(string:"\(baseURL)/account/logout/")!
        var urlRequest = URLRequest(url:url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue(" token \(userToken)",forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: urlRequest){ (data,response,error) in
            if error != nil{
                err = true
                completion(err)
            }
            completion(err)
        }
        task.resume()
    }
    
    func fetchProfile(userToken:String,completion:@escaping([UserInfo])->Void){
        let url = URL(string:"\(baseURL)/user/")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(" token \(userToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: urlRequest){
            (data,response,error) in
            if error==nil && data != nil{
                let jsonDecoder = JSONDecoder()
                do{
                    let userDic = try jsonDecoder.decode([UserInfo].self,from:data!)
                    completion(userDic)
                }
                catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
        task.resume()
    }
    func changeUserPassword(password1:String,password2:String,userToken:String,completion:@escaping(String)->Void){
        var err = ""
        let url = URL(string:"\(baseURL)/account/password/change/")!
        let passwordData = ["new_password1":password1, "new_password2":password2]
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("token \(userToken)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = try? JSONEncoder().encode(passwordData)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: urlRequest){(data,response,error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                let response1 = response as? HTTPURLResponse
                let statusCode = Int(response1?.statusCode ?? 0)
                print(statusCode)
                if statusCode == 400{
                    var dic = try? jsonDecoder.decode([String:[String]].self, from: data)
                    dic = dic ?? ["":[""]]
                    err = dic![dic!.first!.key]![0]
                    completion(err)
                }
                else if statusCode == 200{
                    err = ""
                    completion(err)
                }
                else {
                    err = "Error"
                    completion(err)
                }
            }
        }
        task.resume()
    }
    func deleteUserAccount(userID:String,userToken:String,completion:@escaping()->Void)->Void{
        let url = URL(string:"\(baseURL)/user/\(userID)/")!
        var urlRequest = URLRequest(url:url)
        urlRequest
            .addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue(" token \(userToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil{
                print("error ", error!)
            }
            else{
                completion()
            }
        }
        task.resume()
    }
    
    func userChangeNamePatch(userToken:String,userID:String,firstName:String,lastName:String,completion:@escaping()->Void){
        let url = URL(string:"\(baseURL)/user/\(userID)/")!
        print(url)
        var urlRequest = URLRequest(url:url)
        urlRequest.httpMethod = "PATCH"
        urlRequest
            .addValue("application/json", forHTTPHeaderField: "Content-Type")
        let userData = ["id":userID, "first_name":firstName, "last_name":lastName]
        let jsonEncoder = JSONEncoder()
        urlRequest.httpBody = try? jsonEncoder.encode(userData)
        urlRequest.addValue(" token \(userToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: urlRequest){ (data,response,error) in
            if error != nil{
                print(error as Any)
               return
            }
            completion()
        }
        task.resume()
    }
    
    func fetchExercises(filterSelected:String,completion:@escaping ([ExerciseInfo])->Void){
        print("fetch")
        var homeURL = URL(string:"\(baseURL)/exercises/?ordering=exercise_name")!
        if filterSelected != "" && filterSelected != "All"{
            homeURL = URL(string:"\(baseURL)/exercises/?muscle_group=\(filterSelected)&ordering=exercise_name")!
            print(homeURL)
        }
        let task = URLSession.shared.dataTask(with:homeURL){
            (data,response,err) in
            if err==nil && data != nil{
                let jsonDecoder = JSONDecoder()
                do{
                    let excercisesDic = try jsonDecoder.decode([ExerciseInfo].self,from:data!)
                    completion(excercisesDic)
                }
                catch DecodingError.dataCorrupted(let context) {
                   print(context)
               } catch DecodingError.keyNotFound(let key, let context) {
                   print("Key '\(key)' not found:", context.debugDescription)
                   print("codingPath:", context.codingPath)
               } catch DecodingError.valueNotFound(let value, let context) {
                   print("Value '\(value)' not found:", context.debugDescription)
                   print("codingPath:", context.codingPath)
               } catch DecodingError.typeMismatch(let type, let context) {
                   print("Type '\(type)' mismatch:", context.debugDescription)
                   print("codingPath:", context.codingPath)
               } catch {
                   print("error: ", error)
               }
            }
        }
        task.resume()
    }
    func fetchExercisesSearch(searchParameter: String,completion:@escaping ([ExerciseInfo])->Void){
        var searchParameterSpaces = searchParameter.setSpacesToPlus(searchParameter: searchParameter)
        if searchParameter == ""{
            searchParameterSpaces = "null"
        }
        let searchURL = URL(string:"\(baseURL)/exercises?search=\(searchParameterSpaces)")!
        let task = URLSession.shared.dataTask(with:searchURL){
            (data,response,err) in
            if err==nil && data != nil{
                let jsonDecoder = JSONDecoder()
                do{
                    let excercisesDic = try jsonDecoder.decode([ExerciseInfo].self,from:data!)
                    completion(excercisesDic)
                }
                catch DecodingError.dataCorrupted(let context) {
                   print(context)
               } catch DecodingError.keyNotFound(let key, let context) {
                   print("Key '\(key)' not found:", context.debugDescription)
                   print("codingPath:", context.codingPath)
               } catch DecodingError.valueNotFound(let value, let context) {
                   print("Value '\(value)' not found:", context.debugDescription)
                   print("codingPath:", context.codingPath)
               } catch DecodingError.typeMismatch(let type, let context) {
                   print("Type '\(type)' mismatch:", context.debugDescription)
                   print("codingPath:", context.codingPath)
               } catch {
                   print("error: ", error)
               }
            }
        }
        task.resume()
    }
    
    func fetchUserExercises(searchParameter:String,userToken:String,completion:@escaping([UserExerciseInfo])->Void){
        let searchParameterSpaces = searchParameter.setSpacesToPlus(searchParameter: searchParameter)
        var url = URL(string:"\(baseURL)/notebook/?ordering=-updated_at")!
        if searchParameter != ""{
            url = URL(string:"\(baseURL)/notebook/?search=\(searchParameterSpaces)&ordering=-updated_at")!
        }
        var urlRequest = URLRequest(url:url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(" token \(userToken)", forHTTPHeaderField: "Authorization")
    
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error==nil && data != nil{
                let jsonDecoder = JSONDecoder()
                do{
                    let userExerciseDic = try jsonDecoder.decode([UserExerciseInfo].self,from:data!)
                    completion(userExerciseDic)
                }
                catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
        task.resume()
    }
    
    func userExercisePostRequest(weight:String,uExerciseID:String,unit:String,reps:String,userID:String,userToken:String,completion:@escaping()->Void)->Void{
        let cred =
            ["user": userID,
            "u_exercise": uExerciseID,
            "weight": weight,
            "unit": unit,
            "reps": reps
            ]
        let url = URL(string:"\(baseURL)/notebook/")!
        var urlRequest = URLRequest(url:url)
        urlRequest
            .addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(cred)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue(" token \(userToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            completion()
          print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func deleteUserExercise(entryID:Int,userToken:String)->Void{
        let url = URL(string:"\(baseURL)/notebook/\(entryID)/")!
        var urlRequest = URLRequest(url:url)
        urlRequest
            .addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "DELETE"
        
        urlRequest.addValue(" token \(userToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil{
                print("error ", error!)
            }
        }
        task.resume()
    }
    func updateUserExercisePut(entryID:String,weight:String,unit0:String,reps:String,userID:String,exerciseID:String,userToken:String,completion:@escaping()->Void)->Void{
        let cred = [
            "id": entryID,
            "weight": weight,
            "reps": reps,
            "unit": unit0,
            "user": userID,
            "u_exercise": exerciseID]
        let url = URL(string:"\(baseURL)/notebook/\(entryID)/")!
        var urlRequest = URLRequest(url:url)
        urlRequest
            .addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(cred)
        urlRequest.httpMethod = "PUT"
        
        urlRequest.addValue(" token \(userToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            completion()
          print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
}
