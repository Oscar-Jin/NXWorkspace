//
//  Kintai.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/18.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import Foundation
import Firebase

class Timecard {
  
  var attendedAt: Date?
  var restStartsAt: Date?
  var restEndsAt: Date?
  var offworkAt: Date?
  
  
  var status: Status {
    if attendedAt == nil {return .出勤前}
    if offworkAt != nil {return .退勤後}
    if restStartsAt == nil {return .勤務中}
    else {
      if restEndsAt == nil { return .休憩中}
      if restEndsAt != nil { return .休憩済}
    }
    return .エラー
  }
  
  init(data: [String: Timestamp]) {
    attendedAt = (data["出勤"])?.dateValue()
    restStartsAt = (data["休憩"])?.dateValue()
    restEndsAt = (data["再開"])?.dateValue()
    offworkAt = (data["退勤"])?.dateValue()
  }
  
  init(data: [String: Date]) {
    attendedAt = (data["出勤"])
    restStartsAt = (data["休憩"])
    restEndsAt = (data["再開"])
    offworkAt = (data["退勤"])
  }


}

enum Status: String {
  case 出勤前
  case 勤務中
  case 退勤後
  case 休憩中
  case 休憩済
  case エラー
}

