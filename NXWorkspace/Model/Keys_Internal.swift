//
//  Key.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/15.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import Foundation



struct Timeframe {
  static let time0900_1100 = "09:00 - 11:00"
  static let time1100_1300 = "11:00 - 13:00"
  static let time1300_1500 = "13:00 - 15:00"
  static let time1500_1700 = "15:00 - 17:00"
  static let time1700_1900 = "17:00 - 19:00"
  static let time1730_1930 = "17:30 - 19:30"
  static let time1900_2100 = "19:00 - 21:00"
  static let time1930_2130 = "19:30 - 21:30"
  
  static let selectionItems = [time0900_1100, time1100_1300, time1300_1500, time1500_1700, time1700_1900, time1730_1930, time1900_2100, time1930_2130]
}



struct Class {
  static let L1 = "L1"
  static let L2 = "L2"
  static let L3 = "L3"
  static let L4 = "L4"
  static let L5 = "L5"
  static let A = "A"
  static let B = "B"
  static let C = "C"
  static let D = "D"
  static let E = "E"
  static let F = "F"
  static let G = "G"
  static let H = "H"
  static let I = "I"
  static let I_Jr = "I Jr."
  
  static let GHI = "GHI"
  
  static let 事務 = "事務"
  static let 開発 = "開発"
  
  static let selectionItems = [開発, 事務, L1, L2, L3, L4, L5, A, B, C, D, E, F, G, H, I, I_Jr]
  static let selectionItems_Compact = [開発, 事務, L1, L2, L3, L4, L5, A, B, C, D, E, F, GHI]
  
}




struct Number {
  static let selectionItems = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"]
}





enum Week: Int {
  case monday = 0
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
  case sunday
  
  var string_japanese: String {
    switch self {
    case .monday:  return "月曜日"
    case .tuesday:  return "火曜日"
    case .wednesday:  return "水曜日"
    case .thursday:  return "木曜日"
    case .friday:  return "金曜日"
    case .saturday:  return "土曜日"
    case .sunday:  return "日曜日"
    }
  }
}
