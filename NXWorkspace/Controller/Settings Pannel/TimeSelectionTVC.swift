//
//  TimeSelectionTVC.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/26.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit

class TimeSelectionTVC: UITableViewController {
  var week: Week?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = week?.string_japanese
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let week = week else { return 0 }
    switch week {
    case .monday, .tuesday, .wednesday, .thursday, .friday:  return 4
    case .saturday, .sunday:  return 6
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSelectionCell", for: indexPath) as! TimeSelectionCell
    
    guard let week = week else { return cell }
    switch week {
    
    case .monday, .tuesday, .wednesday, .thursday, .friday:
      if indexPath.row == 0 { cell.timeframe = Timeframe.time1300_1500; cell.week = week }
      if indexPath.row == 1 { cell.timeframe = Timeframe.time1500_1700; cell.week = week }
      if indexPath.row == 2 { cell.timeframe = Timeframe.time1730_1930; cell.week = week }
      if indexPath.row == 3 { cell.timeframe = Timeframe.time1930_2130; cell.week = week }
    
    case .saturday, .sunday:
      if indexPath.row == 0 { cell.timeframe = Timeframe.time0900_1100; cell.week = week }
      if indexPath.row == 1 { cell.timeframe = Timeframe.time1100_1300; cell.week = week }
      if indexPath.row == 2 { cell.timeframe = Timeframe.time1300_1500; cell.week = week }
      if indexPath.row == 3 { cell.timeframe = Timeframe.time1500_1700; cell.week = week }
      if indexPath.row == 4 { cell.timeframe = Timeframe.time1700_1900; cell.week = week }
      if indexPath.row == 5 { cell.timeframe = Timeframe.time1900_2100; cell.week = week }
    }
    
    return cell
  }
  
  
  
}
