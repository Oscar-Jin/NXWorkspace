//
//  ClassLogTVC.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/20.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit

class LessonLogTVC: UITableViewController {

  var lessonLogs = [LessonLog]()

  override func viewDidLoad() {
    super.viewDidLoad()
   
    lessonLogs.append(LessonLog(data: [String: Any]()) )
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let lessonLogCell = tableView.cellForRow(at: indexPath) as? LessonLogCell {
      lessonLogCell.resignAllFirstResponders()
    }
    #warning("might add different type of cell in the future")
  }
  
  
  
  
  
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return lessonLogs.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LessonLogCell", for: indexPath) as! LessonLogCell
    return cell
  }
  
  @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
    lessonLogs.append(LessonLog(data: [String: Any]()) )
    
    self.tableView.beginUpdates()
    self.tableView.insertRows(at: [IndexPath(row: lessonLogs.count - 1, section: 0)], with: .automatic)
    self.tableView.endUpdates()
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      lessonLogs.remove(at: indexPath.row)
      
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }

  

  
  
  
  //MARK: -
  
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
