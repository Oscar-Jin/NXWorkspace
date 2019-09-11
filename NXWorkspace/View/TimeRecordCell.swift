//
//  TimeRecordCell.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/09/09.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit

class TimeRecordCell: UITableViewCell {
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var attendedTimeLabel: UILabel!
  @IBOutlet weak var offworkTimeLabel: UILabel!
  @IBOutlet weak var restTimeLabel: UILabel!
  @IBOutlet weak var talkCountLabel: UILabel!
  
  @IBOutlet weak var optionalMessageLabel: UILabel!
  @IBOutlet weak var incomeLabel: UILabel!
  
  
  var timeRecordVM: TimeRecordVM! {
    didSet {
      dateLabel.text = timeRecordVM.date
      attendedTimeLabel.text = timeRecordVM.attendedTime
      offworkTimeLabel.text = timeRecordVM.offworkTime
      restTimeLabel.text = timeRecordVM.restTime
      talkCountLabel.text = timeRecordVM.talkCount
      
      dateLabel.textColor = timeRecordVM.dateLabelColor
      attendedTimeLabel.textColor = timeRecordVM.attendedTimeLabelColor
      offworkTimeLabel.textColor = timeRecordVM.offworkTimeLabelColor
      restTimeLabel.textColor = timeRecordVM.restTimeLabelColor
      talkCountLabel.textColor = timeRecordVM.talkCountLabelColor
      
      optionalMessageLabel.text = timeRecordVM.optionalMessage
      incomeLabel.text = timeRecordVM.income

    }
  }
  
  
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
}
