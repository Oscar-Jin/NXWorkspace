//
//  CompanySelectionCell.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/16.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit

class CompanySelectionCell: UITableViewCell {
  @IBOutlet weak var companyLabel: UILabel!
  
  var companyName: String! {
    didSet {
      companyLabel.text = companyName
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    companyLabel.text = nil
  }
}
