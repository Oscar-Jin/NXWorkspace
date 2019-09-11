//
//  LessonLogTableVC.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/20.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

class LessonLogTVC: UITableViewController {

  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    print("currentLessonLogs.count", currentLessonLogs.count)
    
    if currentLessonLogs.count == 0 {
      indicator.showSpinner()
      
      let year = String(Calendar.current.component(.year, from: Date()))
      let month = String(Calendar.current.component(.month, from: Date()))
      let day = String(Calendar.current.component(.day, from: Date()))
      
      let query = Firestore.firestore().collection("company").document("001 - LACOMS").collection("lessonLog").whereField("instructorID", isEqualTo: currentUser!.documentID).whereField("year", isEqualTo: year).whereField("month", isEqualTo: month).whereField("day", isEqualTo: day)
      
      query.getDocuments { (snapshot, error) in
        if let error = error { print(error); return }
        if let snapshot = snapshot {
          
          if snapshot.documents.count == 0 {
            print("snapshot.documents.count", snapshot.documents.count)
            let workScheduel = currentUser!.getTodaysWorkSchedule()
            workScheduel.forEach() {
              currentLessonLogs.append(LessonLog(data: ["timeframe": $0]))
            }

          } else {
            print("adding to currentLessonLogs")
            snapshot.documents.forEach() {
              currentLessonLogs.append( LessonLog(data: $0.data()) )
            }

          }
          
          currentLessonLogs.sort(by: { (left, right) -> Bool in
            left.timeframe! < right.timeframe!
          })
          
          indicator.removeSpinner()
          
          self.tableView.reloadData()
        }
      }
    }
  }

  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    #warning("might add different type of cell in the future")
    if let lessonLogCell = tableView.cellForRow(at: indexPath) as? LessonLogCell {
      lessonLogCell.resignAllFirstResponders()
    }
  }
  
  
  
  
  
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentLessonLogs.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LessonLogCell", for: indexPath) as! LessonLogCell
    
    cell.lessonLog = currentLessonLogs[indexPath.row]
    
    return cell
  }
  
  
  
  @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
    currentLessonLogs.append(LessonLog(data: [String: Any]()) )
    
    self.tableView.beginUpdates()
    self.tableView.insertRows(at: [IndexPath(row: currentLessonLogs.count - 1, section: 0)], with: .automatic)
    self.tableView.endUpdates()
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let lessonLog = currentLessonLogs.remove(at: indexPath.row)
      Firestore.firestore().collection("company").document("001 - LACOMS").collection("lessonLog").document(lessonLog.documentID!).delete()
      
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }

  

}
