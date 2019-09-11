//
//  TimeSelectionCell.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/26.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit

class TimeSelectionCell: UITableViewCell {
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var selectionSwitch: UISwitch!
  
  var week: Week! {
    didSet {
      switch week! {
      case .monday:
        if let _ = currentUser?.workOnMonday.firstIndex(of: timeframe) {
          selectionSwitch.setOn(true, animated: false)
        }
        
      case .tuesday:
        if let _ = currentUser?.workOnTuesday.firstIndex(of: timeframe) {
          selectionSwitch.setOn(true, animated: false)
        }
        
      case .wednesday:
        if let _ = currentUser?.workOnWednesday.firstIndex(of: timeframe) {
          selectionSwitch.setOn(true, animated: false)
        }
        
      case .thursday:
        if let _ = currentUser?.workOnThursday.firstIndex(of: timeframe) {
          selectionSwitch.setOn(true, animated: false)
        }
        
      case .friday:
        if let _ = currentUser?.workOnFriday.firstIndex(of: timeframe) {
          selectionSwitch.setOn(true, animated: false)
        }
        
      case .saturday:
        if let _ = currentUser?.workOnSaturday.firstIndex(of: timeframe) {
          selectionSwitch.setOn(true, animated: false)
        }
        
      case .sunday:
        if let _ = currentUser?.workOnSunday.firstIndex(of: timeframe) {
          selectionSwitch.setOn(true, animated: false)
        }
        
      }
    }
  }
  var timeframe: String! {
    didSet {
      timeLabel.text = timeframe
    }
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionSwitch.addTarget(self, action: #selector(self.switched), for: .valueChanged)
  }
  
  @objc func switched() {
    if selectionSwitch.isOn {
      
      switch week! {
      case .monday:
        if var workOnMonday = currentUser?.workOnMonday {
          workOnMonday.append(timeframe)
          workOnMonday.sort(by: <)
          currentUser?.workOnMonday = workOnMonday
        }
        
      case .tuesday:
        if var workOnTuesday = currentUser?.workOnTuesday {
          workOnTuesday.append(timeframe)
          workOnTuesday.sort(by: <)
          currentUser?.workOnTuesday = workOnTuesday
        }
        
      case .wednesday:
        if var workOnWednesday = currentUser?.workOnWednesday {
          workOnWednesday.append(timeframe)
          workOnWednesday.sort(by: <)
          currentUser?.workOnWednesday = workOnWednesday
        }
        
      case .thursday:
        if var workOnThursday = currentUser?.workOnThursday {
          workOnThursday.append(timeframe)
          workOnThursday.sort(by: <)
          currentUser?.workOnThursday = workOnThursday
        }

      case .friday:
        if var workOnFriday = currentUser?.workOnFriday {
          workOnFriday.append(timeframe)
          workOnFriday.sort(by: <)
          currentUser?.workOnFriday = workOnFriday
        }
        
      case .saturday:
        if var workOnSaturday = currentUser?.workOnSaturday {
          workOnSaturday.append(timeframe)
          workOnSaturday.sort(by: <)
          currentUser?.workOnSaturday = workOnSaturday
        }
        
      case .sunday:
        if var workOnSunday = currentUser?.workOnSunday {
          workOnSunday.append(timeframe)
          workOnSunday.sort(by: <)
          currentUser?.workOnSunday = workOnSunday
        }

      }
      
    } else {
      
      switch week! {
      case .monday:
        if let index = currentUser?.workOnMonday.firstIndex(of: timeframe) {
          currentUser?.workOnMonday.remove(at: index)
        }
        
      case .tuesday:
        if let index = currentUser?.workOnTuesday.firstIndex(of: timeframe) {
          currentUser?.workOnTuesday.remove(at: index)
        }
        
      case .wednesday:
        if let index = currentUser?.workOnWednesday.firstIndex(of: timeframe) {
          currentUser?.workOnWednesday.remove(at: index)
        }
        
      case .thursday:
        if let index = currentUser?.workOnThursday.firstIndex(of: timeframe) {
          currentUser?.workOnThursday.remove(at: index)
        }
        
      case .friday:
        if let index = currentUser?.workOnFriday.firstIndex(of: timeframe) {
          currentUser?.workOnFriday.remove(at: index)
        }
        
      case .saturday:
        if let index = currentUser?.workOnSaturday.firstIndex(of: timeframe) {
          currentUser?.workOnSaturday.remove(at: index)
        }
        
      case .sunday:
        if let index = currentUser?.workOnSunday.firstIndex(of: timeframe) {
          currentUser?.workOnSunday.remove(at: index)
        }
        
      }
    }
  }
  
  
  
  
}
