//
//  User.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/16.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import Foundation
import Firebase

class User {
  
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
  
  var workOnMonday: [String] {
    didSet { Firestore.firestore().collection("company").document("001 - LACOMS").collection("user").document(currentUser!.documentID).updateData(["workOnMonday": workOnMonday]) }
  }
  var workOnTuesday: [String] {
    didSet { Firestore.firestore().collection("company").document("001 - LACOMS").collection("user").document(currentUser!.documentID).updateData(["workOnTuesday": workOnTuesday]) }
  }
  var workOnWednesday: [String] {
    didSet { Firestore.firestore().collection("company").document("001 - LACOMS").collection("user").document(currentUser!.documentID).updateData(["workOnWednesday": workOnWednesday]) }
  }
  var workOnThursday: [String] {
    didSet { Firestore.firestore().collection("company").document("001 - LACOMS").collection("user").document(currentUser!.documentID).updateData(["workOnThursday": workOnThursday]) }
  }
  var workOnFriday: [String] {
    didSet { Firestore.firestore().collection("company").document("001 - LACOMS").collection("user").document(currentUser!.documentID).updateData(["workOnFriday": workOnFriday]) }
  }
  var workOnSaturday: [String] {
    didSet { Firestore.firestore().collection("company").document("001 - LACOMS").collection("user").document(currentUser!.documentID).updateData(["workOnSaturday": workOnSaturday]) }
  }
  var workOnSunday: [String] {
    didSet { Firestore.firestore().collection("company").document("001 - LACOMS").collection("user").document(currentUser!.documentID).updateData(["workOnSunday": workOnSunday]) }
  }
  
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
    
    workOnMonday = data["workOnMonday"] as? [String] ?? []
    workOnTuesday = data["workOnTuesday"] as? [String] ?? []
    workOnWednesday = data["workOnWednesday"] as? [String] ?? []
    workOnThursday = data["workOnThursday"] as? [String] ?? []
    workOnFriday = data["workOnFriday"] as? [String] ?? []
    workOnSaturday = data["workOnSaturday"] as? [String] ?? []
    workOnSunday = data["workOnSunday"] as? [String] ?? []
  }
  
  var documentData: [String: Any] {
    let user: [String: Any] = [
      "lastName_Kanji": lastName_Kanji,
      "lastName_Hiragana": lastName_Hiragana,
      "firstName_Kanji": firstName_Kanji,
      "firstName_Hiragana": firstName_Hiragana,
      
      "affiliatedWith": affiliatedWith,
      "team": team,
      
      "gender": gender,
      "birthDay": birthDay,
      "documentID": documentID,
      
      "photoID": photoID as Any,
      "photoURL": photoURL as Any,
      
      "createdOn": createdOn,
      "updatedOn": updatedOn,
      
      "password": password,
      
      "workOnMonday": workOnMonday as Any,
      "workOnTuesday": workOnTuesday as Any,
      "workOnWednesday": workOnWednesday as Any,
      "workOnThursday": workOnThursday as Any,
      "workOnFriday": workOnFriday as Any,
      "workOnSaturday": workOnSaturday as Any,
      "workOnSunday": workOnSunday as Any,
    ]
    return user
  }
  
  
  
}

extension User {
  var fullName: String {
    return lastName_Kanji + "  " + firstName_Kanji
  }
  
  func getTodaysWorkSchedule() -> [String] {
    let week = Calendar.current.component(.weekday, from: Date())
    
    if week == 1 { return workOnSunday }
    if week == 2 { return workOnMonday }
    if week == 3 { return workOnTuesday }
    if week == 4 { return workOnWednesday }
    if week == 5 { return workOnThursday }
    if week == 6 { return workOnFriday }
    if week == 7 { return workOnSaturday }
    
    return []
  }
}
