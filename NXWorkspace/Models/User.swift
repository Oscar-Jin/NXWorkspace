//
//  User.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/16.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import Foundation
import Firebase

struct User {
  var lastName_Kanji: String
  var lastName_Hiragana: String
  var firstName_Kanji: String
  var firstName_Hiragana: String
  
  var affiliatedWith: String
  var team: String
  
  var gender: String
  var birthDay: Date
  var documentID: String
  
  var photoID: String?
  var photoURL: String?
  
  var createdOn: Date
  var updatedOn: Date
  
  var password: String
  
  init(data: [String: Any]) {
    lastName_Kanji = data["lastName_Kanji"] as? String ?? ""
    lastName_Hiragana = data["lastName_Hiragana"] as? String ?? ""
    firstName_Kanji = data["firstName_Kanji"] as? String ?? ""
    firstName_Hiragana = data["firstName_Hiragana"] as? String ?? ""
    
    affiliatedWith = data["affiliatedWith"] as? String ?? ""
    team = data["team"] as? String ?? ""
    
    gender = data["gender"] as? String ?? ""
    birthDay = (data["birthDay"] as? Timestamp)?.dateValue() ?? Date(timeIntervalSince1970: 0)
    documentID = data["documentID"] as? String ?? ""
    
    photoID = data["photoID"] as? String
    photoURL = data["photoURL"] as? String
    
    createdOn = (data["createdOn"] as? Timestamp)?.dateValue() ?? Date(timeIntervalSince1970: 0)
    updatedOn = (data["updatedOn"] as? Timestamp)?.dateValue() ?? Date(timeIntervalSince1970: 0)
    
    password = data["password"] as! String
  }
  
  
  
}

extension User {
  var fullName: String {
    return lastName_Kanji + "  " + firstName_Kanji
  }
}
