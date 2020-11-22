//
//  Talk.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/20.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import Foundation
import Firebase

class LessonLog {
  var timeframe: String? {
    didSet { Firestore.firestore().collection("company").document("001 - LACOMS").collection("lessonLog").document(documentID!).updateData(["timeframe": timeframe ?? "", "updatedOn": Date()]) }
  }
  var classLevel: String? {
    didSet { Firestore.firestore().collection("company").document("001 - LACOMS").collection("lessonLog").document(documentID!).updateData(["classLevel": classLevel ?? "", "updatedOn": Date()]) }
  }
  var attendanceNumber: String? {
    didSet { Firestore.firestore().collection("company").document("001 - LACOMS").collection("lessonLog").document(documentID!).updateData(["attendanceNumber": attendanceNumber ?? "", "updatedOn": Date()]) }
  }
  var talk: String? {
     didSet { Firestore.firestore().collection("company").document("001 - LACOMS").collection("lessonLog").document(documentID!).updateData(["talk": talk ?? "", "updatedOn": Date()]) }
  }
  
  var documentID: String?
  var instructorID: String?
  var instructorFullName: String?
  
  var createdOn: Date?
  var updatedOn: Date?
  
  var year: String?
  var month: String?
  var day: String?
  
  init(data: [String: Any]) {
    timeframe = data["timeframe"] as? String
    classLevel = data["classLevel"] as? String
    attendanceNumber = data["attendanceNumber"] as? String
    talk = data["talk"] as? String
    
    documentID = data["documentID"] as? String
    instructorID = data["instructorID"] as? String
    instructorFullName = data["instructorFullName"] as? String
    
    createdOn = (data["createdOn"] as? Timestamp)?.dateValue()
    updatedOn = (data["updatedOn"] as? Timestamp)?.dateValue()
    
    year = data["year"] as? String
    month = data["month"] as? String
    day = data["day"] as? String
    
    if data["documentID"] == nil {
      addDocumentToFirestore()
    }
  }
  
  func addDocumentToFirestore() {

      let data: [String: Any] = [
        "timeframe": timeframe as Any,
        "classLevel": classLevel as Any,
        "attendanceNumber": attendanceNumber as Any,
        "talk": talk as Any,
        
        "instructorID": currentUser!.documentID,
        "instructorFullName": currentUser!.fullName,
        
        "createdOn": Date(),
        "updatedOn": Date(),
        
        "year": String(Calendar.current.component(.year, from: Date())),
        "month": String(Calendar.current.component(.month, from: Date())),
        "day": String(Calendar.current.component(.day, from: Date())),
      ]
    
      let reference = Firestore.firestore().collection("company").document("001 - LACOMS").collection("lessonLog").addDocument(data: data)
      reference.updateData(["documentID": reference.documentID])
      documentID = reference.documentID
    
  }
}







