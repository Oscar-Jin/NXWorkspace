//
//  WorkRecordTVC.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/09/09.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

class TimeRecordTVC: UITableViewController {
  
  var selectedMonth: Int!
  var selectedYear: Int!
  
  var userLessonLogsQuery = [LessonLog]() {
    didSet { tableView.reloadData() }
  }
  
  var userTimecardQuery = [Timecard]() {
    didSet { tableView.reloadData() }
  }
  
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    selectedMonth = Calendar.current.component(.month, from: Date())
    selectedYear = Calendar.current.component(.year, from: Date())
    
    dataQuery(month: selectedMonth, year: selectedYear)
  }
  
  
  
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .current
    dateFormatter.dateFormat = "MMMM"
   
    return dateFormatter.string(from: Calendar.current.date(from: DateComponents(year: Int(selectedYear), month: Int(selectedMonth)))!)
  }
  

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userTimecardQuery.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TimeRecordCell", for: indexPath) as! TimeRecordCell
    
    
    let day = String(Calendar.current.component(.day, from: userTimecardQuery[indexPath.row].attendedAt!))
    let lessonLogsArray = userLessonLogsQuery.filter() { $0.day == day }
    
    
    cell.timeRecordVM = TimeRecordVM(timecard: userTimecardQuery[indexPath.row], lessonLogs: lessonLogsArray)
    return cell
  }

  
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
  
  
  // big mistake: should set lessonLogs meta_ year, month, day to Int instead of String
  func dataQuery(month: Int, year: Int) {
    
    var lessonLogs = [LessonLog]()
    var timecards = [Timecard]()
    
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("lessonLog").whereField("instructorFullName", isEqualTo: currentUser?.fullName ?? "failsafe").whereField("year", isEqualTo: String(year)).whereField("month", isEqualTo: String(month)).getDocuments { (snapshot, error) in
      
      if let _ = error { return }
      if let snapshot = snapshot {
        snapshot.documents.forEach() {
          lessonLogs.append(LessonLog(data: $0.data()))
        }
      }
      self.userLessonLogsQuery = lessonLogs
    }
    
    
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("timecard").order(by: "day").whereField("year", isEqualTo: year).whereField("month", isEqualTo: month).getDocuments { (snapshot, error) in
      
      if let _ = error { return }
      if let snapshot = snapshot {
        snapshot.documents.forEach() {
          if let data = $0.data()[currentUser?.fullName ?? "failsafe"] as? [String: Timestamp] {
            timecards.append(Timecard(data: data))
          }
        }
      }
      self.userTimecardQuery = timecards.reversed()
    }
    
    
  }
  
  

}
