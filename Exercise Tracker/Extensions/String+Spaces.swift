//
//  String+Spaces.swift
//  Exercise Tracker
//
//  Created by Juvraj on 12/7/21.
//

import Foundation

extension String{
    func setSpacesToPlus(searchParameter:String)->String{
        let newString = searchParameter.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        return newString
    }
}
