//
//  UserSelectionCell.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/15.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit

class UserSelectionCell: UITableViewCell {
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  
  var user: User? {
    didSet {
      userImageView.image = UIImage(named: user?.lastName_Kanji ?? "unknown")
      userNameLabel.text = user?.fullName
    }
  }
}
