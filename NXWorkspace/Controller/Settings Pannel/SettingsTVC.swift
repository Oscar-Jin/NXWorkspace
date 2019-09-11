//
//  SettingsTVC.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/20.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

class SettingsTVC: UITableViewController {
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    userImageView.image = UIImage(named: currentUser?.lastName_Kanji ?? "failsafe")
    userNameLabel.text = currentUser?.fullName
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 2 && indexPath.row == 0 {
      let alert =  UIAlertController(title: "人生嫌いになりましたか？", message: "ならば金ちゃんとコーヒーにでも行きませんか？☕️ お悩みを一人で抱えないでくださいね☺️",preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alert, animated: true, completion: nil)
    }
  }
  
  
}
