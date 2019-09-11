//
//  TimeRecordVM.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/09/09.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import Foundation
import UIKit

struct TimeRecordVM {
  let date: String
  
  let attendedTime: String
  let offworkTime: String
  let restTime: String
  let talkCount: String
  
  
  let dateLabelColor: UIColor
  
  let attendedTimeLabelColor: UIColor
  let offworkTimeLabelColor: UIColor
  let restTimeLabelColor: UIColor
  let talkCountLabelColor: UIColor
  
  
  let optionalMessage: String
  let income: String
  
  
  let timecard: Timecard
  let lessonLogs: [LessonLog]
  
  init(timecard: Timecard, lessonLogs: [LessonLog]) {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .current
    dateFormatter.dateFormat = "MM/dd(EEE)"
    
    if let date = timecard.attendedAt {
      self.date = dateFormatter.string(from: date)
      self.dateLabelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    else {
      self.date = "Error"
      self.dateLabelColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    }
    
    
    if let attendedAt = timecard.attendedAt {
      self.attendedTime = DateFormatter.localizedString(from: attendedAt, dateStyle: .none, timeStyle: .medium)
      self.attendedTimeLabelColor = #colorLiteral(red: 0, green: 0.6888964176, blue: 0.09359545261, alpha: 1)
    }
    else {
      self.attendedTime = "未出勤"
      self.attendedTimeLabelColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    }
    
    
    if let offworkAt = timecard.offworkAt {
      self.offworkTime = DateFormatter.localizedString(from: offworkAt, dateStyle: .none, timeStyle: .medium)
      self.offworkTimeLabelColor = #colorLiteral(red: 0, green: 0.6888964176, blue: 0.09359545261, alpha: 1)
    }
    else {
      self.offworkTime = "未退勤"
      self.offworkTimeLabelColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    }
    
    
    if let restStartsAt = timecard.restStartsAt, let restEndsAt = timecard.restEndsAt {
      let calendar = Calendar.current
      let components = calendar.dateComponents([.hour, .minute], from: restStartsAt, to: restEndsAt)
      
      self.restTime = String(components.hour!) + ":" + (String(components.minute!).count == 1 ? "0\(components.minute!)" : "\(components.minute!)")
      
      if components.hour! < 1 {
        self.restTimeLabelColor = #colorLiteral(red: 0, green: 0.6888964176, blue: 0.09359545261, alpha: 1)
      } else {
        self.restTimeLabelColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
      }
      
    }
    else {
      self.restTime = "0:00"
      self.restTimeLabelColor = #colorLiteral(red: 0, green: 0.6888964176, blue: 0.09359545261, alpha: 1)
    }
    
    
    var string = ""
    lessonLogs.forEach() { _ in string += "⦿" }
    
    if lessonLogs.count == 0 {
      self.talkCount = "未記入"
      self.talkCountLabelColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    } else {
      self.talkCount = string
      self.talkCountLabelColor = #colorLiteral(red: 0, green: 0.6888964176, blue: 0.09359545261, alpha: 1)
    }
    

    
    
    
    self.timecard = timecard
    self.lessonLogs = lessonLogs
    
    
    #warning("not yet complete - incomplete implementation")
    self.optionalMessage = ""
    
    
    
    
    // daily income calculator
    
    for lessonlog in lessonLogs {
      
      
    }
    
    
    
    self.income = ""

  }
  
}


