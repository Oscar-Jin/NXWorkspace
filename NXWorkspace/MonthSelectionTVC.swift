//
//  MonthSelectionTVC.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/25.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

class MonthSelectionTVC: UITableViewController {
  @IBOutlet weak var mondayLabel: UILabel!
  @IBOutlet weak var tuesdayLabel: UILabel!
  @IBOutlet weak var wednesdayLabel: UILabel!
  @IBOutlet weak var thursdayLabel: UILabel!
  @IBOutlet weak var fridayLabel: UILabel!
  @IBOutlet weak var saturdayLabel: UILabel!
  @IBOutlet weak var sundayLabel: UILabel!
  
  var selectedRow = 0

  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let tabItem  = tabBarController?.tabBar.items?[2] { tabItem.badgeValue = nil }
    
    if let array = currentUser?.workOnMonday, array != [] { mondayLabel.textColor = #colorLiteral(red: 0.9018921256, green: 0.3716083765, blue: 0.3906248808, alpha: 1) } else { mondayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
    if let array = currentUser?.workOnTuesday, array != [] { tuesdayLabel.textColor = #colorLiteral(red: 0.9018921256, green: 0.3716083765, blue: 0.3906248808, alpha: 1) } else { tuesdayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
    if let array = currentUser?.workOnWednesday, array != [] { wednesdayLabel.textColor = #colorLiteral(red: 0.9018921256, green: 0.3716083765, blue: 0.3906248808, alpha: 1) } else { wednesdayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
    if let array = currentUser?.workOnThursday, array != [] { thursdayLabel.textColor = #colorLiteral(red: 0.9018921256, green: 0.3716083765, blue: 0.3906248808, alpha: 1) } else { thursdayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
    if let array = currentUser?.workOnFriday, array != [] { fridayLabel.textColor = #colorLiteral(red: 0.9018921256, green: 0.3716083765, blue: 0.3906248808, alpha: 1) } else { fridayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
    if let array = currentUser?.workOnSaturday, array != [] { saturdayLabel.textColor = #colorLiteral(red: 0.9018921256, green: 0.3716083765, blue: 0.3906248808, alpha: 1) } else { saturdayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
    if let array = currentUser?.workOnSunday, array != [] { sundayLabel.textColor = #colorLiteral(red: 0.9018921256, green: 0.3716083765, blue: 0.3906248808, alpha: 1) } else { sundayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedRow = indexPath.row
    performSegue(withIdentifier: "showTimeSelectionSegue", sender: self)
  }
  
  
  

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let timeSelectionTVC = segue.destination as! TimeSelectionTVC
    
    timeSelectionTVC.week = Week(rawValue: selectedRow)
   }

  
}
