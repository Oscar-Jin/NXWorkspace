//
//  ViewController.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/14.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

var currentUser: User?
var currentLessonLogs = [LessonLog]()
var indicator = IndicatorView()

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var discriptionLabel: UILabel!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var dateDisplayLabel: UILabel!
  @IBOutlet weak var timeDisplayLabel: UILabel!
  @IBOutlet weak var dayOfWeekDisplayLabel: UILabel!
  @IBOutlet weak var todaysInfoView: UIImageView!
  
  @IBOutlet weak var totalWorkTimeLabel: UILabel!
  @IBOutlet weak var attendanceTimeLabel: UILabel!
  @IBOutlet weak var offworkTimeLabel: UILabel!
  @IBOutlet weak var restTimeLabel: UILabel!
  
  @IBOutlet weak var workStatusLabel: UILabel!
  
  @IBOutlet weak var attendanceButton: UIButton!
  @IBOutlet weak var breakButton: UIButton!
  @IBOutlet weak var resumeButton: UIButton!
  @IBOutlet weak var offWorkButton: UIButton!
  @IBOutlet weak var alreadyOffWorkButton: UIButton!
  
  @IBOutlet weak var infoImageView: UIImageView!
  
  @IBOutlet weak var classScheduleTableView: UITableView!
  
  
  
  
  var timer0: Timer?
  var timer1: Timer?
  var timer2: Timer?
  var timer3: Timer?
  
  var user: User? {
    didSet {
      nameLabel.text = user?.fullName
      discriptionLabel.text = user?.team
      userImageView.image = UIImage(named: user?.lastName_Kanji ?? "failsafe")
      currentUser = user
    }
  }
  
  var timecard: Timecard? {
    didSet {
      timer2?.invalidate()
      timer3?.invalidate()
      
      totalWorkTimeLabel.text = "勤務時間： "
      attendanceTimeLabel.text = "出社時間： "
      offworkTimeLabel.text = "退社時間： "
      restTimeLabel.text = "休憩時間： "
      
      if let attendedAt = timecard?.attendedAt, let restStartsAt = timecard?.restStartsAt, let restEndsAt = timecard?.restEndsAt, let offworkAt = timecard?.offworkAt {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.second], from: attendedAt, to: offworkAt)
        let components2 = calendar.dateComponents([.second], from: restStartsAt, to: restEndsAt)
        let components3 = calendar.dateComponents([.hour, .minute], from: restStartsAt, to: restEndsAt)
        
        let difference = components1.second! - components2.second!
        let (h,m,_) = self.secondsToHoursMinutesSeconds(seconds: difference)
        totalWorkTimeLabel.text = "勤務時間： " + String(h) + ":" + (String(m).count == 1 ? "0\(m)" : String(m))
        attendanceTimeLabel.text = "出社時間： " + DateFormatter.localizedString(from: attendedAt, dateStyle: .none, timeStyle: .medium)
        offworkTimeLabel.text = "退社時間： " + DateFormatter.localizedString(from: offworkAt, dateStyle: .none, timeStyle: .medium)
        restTimeLabel.text = "休憩時間： " + String(components3.hour!) + ":" + (String(components3.minute!).count == 1 ? "0\(components3.minute!)" : "\(components3.minute!)")
        
      } else if let attendedAt = timecard?.attendedAt, let restStartsAt = timecard?.restStartsAt, let restEndsAt = timecard?.restEndsAt {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: restStartsAt, to: restEndsAt)
        restTimeLabel.text = "休憩時間： " + String(components.hour!) + ":" + (String(components.minute!).count == 1 ? "0\(components.minute!)" : "\(components.minute!)")
        attendanceTimeLabel.text = "出社時間： " + DateFormatter.localizedString(from: attendedAt, dateStyle: .none, timeStyle: .medium)
        //*********
        let components1 = calendar.dateComponents([.second], from: attendedAt, to: Date())
        let components2 = calendar.dateComponents([.second], from: restStartsAt, to: restEndsAt)
        let difference = components1.second! - components2.second!
        let (h,m,_) = self.secondsToHoursMinutesSeconds(seconds: difference)
        self.totalWorkTimeLabel.text = "勤務時間： " + String(h) + ":" + (String(m).count == 1 ? "0\(m)" : String(m))
        //*********
        timer2 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
          let calendar = Calendar.current
          let components1 = calendar.dateComponents([.second], from: attendedAt, to: Date())
          let components2 = calendar.dateComponents([.second], from: restStartsAt, to: restEndsAt)
          let difference = components1.second! - components2.second!
          let (h,m,_) = self.secondsToHoursMinutesSeconds(seconds: difference)
          self.totalWorkTimeLabel.text = "勤務時間： " + String(h) + ":" + (String(m).count == 1 ? "0\(m)" : String(m))
        })
        
      } else if let attendedAt = timecard?.attendedAt, let restStartsAt = timecard?.restStartsAt {
        attendanceTimeLabel.text = "出社時間： " + DateFormatter.localizedString(from: attendedAt, dateStyle: .none, timeStyle: .medium)
        timer3 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
          let calendar = Calendar.current
          let components = calendar.dateComponents([.hour, .minute], from: restStartsAt, to: Date())
          let components2 = calendar.dateComponents([.hour, .minute], from: attendedAt, to: restStartsAt)
          self.restTimeLabel.text = "休憩時間： " + String(components.hour!) + ":" + (String(components.minute!).count == 1 ? "0\(components.minute!)" : "\(components.minute!)")
          self.totalWorkTimeLabel.text = "勤務時間： " + String(components2.hour!) + ":" + (String(components2.minute!).count == 1 ? "0\(components2.minute!)" : "\(components2.minute!)")
        })
      
      } else if let attendedAt = timecard?.attendedAt, let offworkAt = timecard?.offworkAt {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: attendedAt, to: offworkAt)
        totalWorkTimeLabel.text = "勤務時間： " + String(components.hour!) + ":" + (String(components.minute!).count == 1 ? "0\(components.minute!)" : "\(components.minute!)")
        attendanceTimeLabel.text = "出社時間： " + DateFormatter.localizedString(from: attendedAt, dateStyle: .none, timeStyle: .medium)
        offworkTimeLabel.text = "退社時間： " + DateFormatter.localizedString(from: offworkAt, dateStyle: .none, timeStyle: .medium)
      
      } else if let attendedAt = timecard?.attendedAt {
        attendanceTimeLabel.text = "出社時間： " + DateFormatter.localizedString(from: attendedAt, dateStyle: .none, timeStyle: .medium)
        //*****
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: attendedAt, to: Date())
        self.totalWorkTimeLabel.text = "勤務時間： " + String(components.hour!) + ":" + (String(components.minute!).count == 1 ? "0\(components.minute!)" : "\(components.minute!)")
        //*****
        timer2 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
          let calendar = Calendar.current
          let components = calendar.dateComponents([.hour, .minute], from: attendedAt, to: Date())
          self.totalWorkTimeLabel.text = "勤務時間： " + String(components.hour!) + ":" + (String(components.minute!).count == 1 ? "0\(components.minute!)" : "\(components.minute!)")
        })
      }
      
      
      if timecard != nil {
        print("switching...")
        switch self.timecard!.status {
        case .出勤前:
          print("/出勤前")
          self.workStatusLabel.text = "出勤前"
          self.workStatusLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
          self.attendanceButton.isHidden = false
          self.breakButton.isHidden = true
          self.resumeButton.isHidden = true
          self.offWorkButton.isHidden = true
          self.alreadyOffWorkButton.isHidden = true
          
        case .勤務中:
          print("/勤務中")
          self.workStatusLabel.text = "勤務中"
          self.workStatusLabel.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
          self.attendanceButton.isHidden = true
          self.breakButton.isHidden = false
          self.resumeButton.isHidden = true
          self.offWorkButton.isHidden = false
          self.alreadyOffWorkButton.isHidden = true
          
        case .休憩中:
          print("/休憩中")
          self.workStatusLabel.text = "休憩中"
          self.workStatusLabel.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
          self.attendanceButton.isHidden = true
          self.breakButton.isHidden = true
          self.resumeButton.isHidden = false
          self.offWorkButton.isHidden = true
          self.alreadyOffWorkButton.isHidden = true
          
        case .休憩済:
          print("/休憩済")
          self.workStatusLabel.text = "勤務中"
          self.workStatusLabel.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
          self.attendanceButton.isHidden = true
          self.breakButton.isHidden = true
          self.resumeButton.isHidden = true
          self.offWorkButton.isHidden = false
          self.alreadyOffWorkButton.isHidden = true
          
        case .退勤後:
          print("/退勤済")
          self.workStatusLabel.text = "退勤済"
          self.workStatusLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
          self.attendanceButton.isHidden = true
          self.breakButton.isHidden = true
          self.resumeButton.isHidden = true
          self.offWorkButton.isHidden = true
          self.alreadyOffWorkButton.isHidden = false
        case .エラー:
          print("/エラー")
          self.workStatusLabel.text = "エラー"
          self.workStatusLabel.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
          self.attendanceButton.isHidden = true
          self.breakButton.isHidden = true
          self.resumeButton.isHidden = true
          self.offWorkButton.isHidden = true
          self.alreadyOffWorkButton.isHidden = true
          
        }
        
      } else {
        print("/kintai == nil")
        self.workStatusLabel.text = "出勤前"
        self.workStatusLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.attendanceButton.isHidden = false
        self.breakButton.isHidden = true
        self.resumeButton.isHidden = true
        self.offWorkButton.isHidden = true
        self.alreadyOffWorkButton.isHidden = true
        
      }
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startTimer()
    startHasPassedADayTimer()
    
    setButtonsToHaveShadow()
    randomPicture()
    
    classScheduleTableView.delegate = self
    classScheduleTableView.dataSource = self
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    checkHasUserLogedIn()
  }
  
  
  //MARK: - User Interactions *******************************************
  
  @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
    UserDefaults.standard.set(false, forKey: "hasUserLogedIn")
    checkHasUserLogedIn()
  }
  
  @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
    if timecard?.status == Status.退勤後 {
      let alert =  UIAlertController(title: "既に退勤済です", message: "退勤後の編集はできません", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alert, animated: true, completion: nil)
      return
    }
    
    self.performSegue(withIdentifier: "showTalkViewSegue", sender: self)
  }
  
  
  @IBAction func attendanceButtonTapped(_ sender: UIButton) {
    attendedNow()
  }
  
  @IBAction func breakButtonTapped(_ sender: UIButton) {
    restStartNow()
  }
  
  @IBAction func resumeButtonTapped(_ sender: UIButton) {
    restEndsNow()
  }
  
  @IBAction func offWorkButtonTapped(_ sender: UIButton) {
    checkAllLessonLogs()
  }
  
  
  //MARK: - Table View Delegates *******************************************
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ClassTempelateCell", for: indexPath)
    switch indexPath.row {
    case 0: cell.textLabel?.text = "L4    Template"; cell.detailTextLabel?.text = Timeframe.time1300_1500
    case 1: cell.textLabel?.text = "E    Template"; cell.detailTextLabel?.text = Timeframe.time1500_1700
    case 2: cell.textLabel?.text = "GHI    Template"; cell.detailTextLabel?.text = Timeframe.time1730_1930
    case 3: cell.textLabel?.text = "事務    Template"; cell.detailTextLabel?.text = Timeframe.time1930_2130
    default: cell.textLabel?.text = nil; cell.detailTextLabel?.text = nil
    }
    return cell
  }
  
  
  
  
  
  
}






//MARK: - Internal Logics ***********************************************

extension HomeViewController {
  
  func checkHasUserLogedIn() {
    let hasLogedIn = UserDefaults.standard.bool(forKey: "hasUserLogedIn")
    
    if hasLogedIn {
      guard let userID = UserDefaults.standard.string(forKey: "userID") else {return}
      guard let userFullName = UserDefaults.standard.string(forKey: "userFullName") else {return}
      
      view.isHidden = false
      retrieveUser(with: userID, andAssign: &user)
      retrieveTimecard(with: userFullName, andAssign: &timecard)
      
    } else {
      user = nil
      timecard = nil
      currentLessonLogs = []
      view.isHidden = true
      performSegue(withIdentifier: "showLoginViewSegue", sender: self)
    }
    
  }
  
  func retrieveUser(with userID: String, andAssign user: inout User?) {
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("user").whereField("documentID", isEqualTo: userID).getDocuments { (snapshot, error) in
      guard let document = snapshot?.documents.first else { UserDefaults.standard.set(false, forKey: "hasUserLogedIn"); return}
      self.user = User(data: document.data())
    }
  }
  
  func retrieveTimecard(with fullName: String, andAssign timecard: inout Timecard?) {
    let year = String(Calendar.current.component(.year, from: Date()))
    let month = String(Calendar.current.component(.month, from: Date()))
    let day = String(Calendar.current.component(.day, from: Date()))
    let today = year + "_" + month + "_" + day
    
    
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("timecard").document(today).getDocument { (snapshot, error) in
      guard let snapshot = snapshot, let timecardData = snapshot.data()?[fullName] as? [String: Timestamp] else {self.timecard = nil; return}
      self.timecard = Timecard(data: timecardData)
    }
  }

  
  
  func attendedNow() {
    guard let userFullName = UserDefaults.standard.string(forKey: "userFullName") else {return}
    let year = Calendar.current.component(.year, from: Date())
    let month = Calendar.current.component(.month, from: Date())
    let day = Calendar.current.component(.day, from: Date())
    let today = String(year) + "_" + String(month) + "_" + String(day)
    
    var data = [String: Date]()
    if let attendedAt = timecard?.attendedAt { data["出勤"] = attendedAt }
    if let restStartsAt  = timecard?.restStartsAt { data["休憩"] = restStartsAt }
    if let restEndsAt = timecard?.restEndsAt { data["再開"] = restEndsAt }
    if let offworkAt = timecard?.offworkAt { data["退勤"] = offworkAt }
    
    data["出勤"] = Date()
    
    
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("timecard").document(today).getDocument { (snapshot, error) in
      if let error = error { print(error); return }
      if let _ = snapshot?.data() { return }
      else {
        print("file not found. set new file")
        Firestore.firestore().collection("company").document("001 - LACOMS").collection("timecard").document(today).setData([userFullName: data, "year": year, "month": month, "day": day])
      }
    }
    
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("timecard").document(today).updateData([userFullName: data]) { (error) in
      if let error = error { print(error); return }
      self.timecard = Timecard(data: data)
    }
  }
  
  func offWorkNow() {
    guard let userFullName = UserDefaults.standard.string(forKey: "userFullName") else {return}
    
    let year = String(Calendar.current.component(.year, from: Date()))
    let month = String(Calendar.current.component(.month, from: Date()))
    let day = String(Calendar.current.component(.day, from: timecard?.attendedAt ?? Date()))
    let today = year + "_" + month + "_" + day
    
    var data = [String: Date]()
    if let attendedAt = timecard?.attendedAt {data["出勤"] = attendedAt }
    if let restStartsAt  = timecard?.restStartsAt {data["休憩"] = restStartsAt }
    if let restEndsAt = timecard?.restEndsAt {data["再開"] = restEndsAt }
    if let offworkAt = timecard?.offworkAt {data["退勤"] = offworkAt }
    
    data["退勤"] = Date()
    
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("timecard").document(today).updateData([userFullName: data]) { (error) in
      if let error = error { print(error); return }
      self.timecard = Timecard(data: data)
    }
  }
  
  func restStartNow() {
    guard let userFullName = UserDefaults.standard.string(forKey: "userFullName") else {return}
    
    let year = String(Calendar.current.component(.year, from: Date()))
    let month = String(Calendar.current.component(.month, from: Date()))
    let day = String(Calendar.current.component(.day, from: Date()))
    let today = year + "_" + month + "_" + day
    
    var data = [String: Date]()
    if let attendedAt = timecard?.attendedAt {data["出勤"] = attendedAt }
    if let restStartsAt  = timecard?.restStartsAt {data["休憩"] = restStartsAt }
    if let restEndsAt = timecard?.restEndsAt {data["再開"] = restEndsAt }
    if let offworkAt = timecard?.offworkAt {data["退勤"] = offworkAt }
    
    data["休憩"] = Date()

    Firestore.firestore().collection("company").document("001 - LACOMS").collection("timecard").document(today).updateData([userFullName: data]) { (error) in
      if let error = error { print(error); return }
      self.timecard = Timecard(data: data)
    }
    
  }
  
  func restEndsNow() {
    guard let userFullName = UserDefaults.standard.string(forKey: "userFullName") else {return}
    
    let year = String(Calendar.current.component(.year, from: Date()))
    let month = String(Calendar.current.component(.month, from: Date()))
    let day = String(Calendar.current.component(.day, from: Date()))
    let today = year + "_" + month + "_" + day
    
    var data = [String: Date]()
    if let attendedAt = timecard?.attendedAt {data["出勤"] = attendedAt }
    if let restStartsAt  = timecard?.restStartsAt {data["休憩"] = restStartsAt }
    if let restEndsAt = timecard?.restEndsAt {data["再開"] = restEndsAt }
    if let offworkAt = timecard?.offworkAt {data["退勤"] = offworkAt }
    
    data["再開"] = Date()
    
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("timecard").document(today).updateData([userFullName: data]) { (error) in
      if let error = error { print(error); return }
      self.timecard = Timecard(data: data)
    }
  }
  
  
  
  func startTimer() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE", options: 0, locale: .current)
    
    dateDisplayLabel.text = nil
    timeDisplayLabel.text = nil
    dayOfWeekDisplayLabel.text = nil
    
    timer1 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
      self.timeDisplayLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
      self.dateDisplayLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
      self.dayOfWeekDisplayLabel.text = dateFormatter.string(from: Date())
    })
  }
  
  func randomPicture() {
    let number = Int.random(in: 1...13)
    infoImageView.image = UIImage(named: "bg\(number)")
  }
  
  func startHasPassedADayTimer() {
    timer0 = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true, block: { _ in
      guard let attendedAt = self.timecard?.attendedAt else {return}
      if Calendar.current.component(.day, from: attendedAt) != Calendar.current.component(.day, from: Date()) {
        if let _ = self.timecard?.offworkAt {
          self.checkHasUserLogedIn()
        } else {
          //TODO:
          #warning("not yet fixed")
          self.checkHasUserLogedIn()
        }
      }
    })
  }
  
  func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
  }
  
  
  func setButtonsToHaveShadow() {
    let buttonArray = [attendanceButton, breakButton, resumeButton, offWorkButton, alreadyOffWorkButton]

    buttonArray.forEach() {
      $0?.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      $0?.layer.shadowRadius = 2
      $0?.layer.shadowOpacity = 0.17
      $0?.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
  }
  
  
  func checkAllLessonLogs() {
    if currentLessonLogs.count == 0 {
      let alert =  UIAlertController(title: "まだ勤務記録を書いていません！", message: "本日の勤務記録を書いてください。" ,preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        self.performSegue(withIdentifier: "showTalkViewSegue", sender: self)
      }))
      present(alert, animated: true, completion: nil)
      return
    }
    
    
    currentLessonLogs.forEach() {
      if $0.timeframe == nil || $0.classLevel == nil || $0.attendanceNumber == nil || $0.talk == nil || $0.timeframe == "" || $0.classLevel == "" || $0.attendanceNumber == "" || $0.talk == "" {

        let alert =  UIAlertController(title: "記入漏れがあります！", message: "本日の勤務記録にまだ記入されていない項目がございます" ,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
          self.performSegue(withIdentifier: "showTalkViewSegue", sender: self)
        }))
        present(alert, animated: true, completion: nil)
        return
      }
    }
    
    if currentLessonLogs.count < currentUser!.getTodaysWorkSchedule().count {
      let alert =  UIAlertController(title: "警告：勤務記録の数が足りません", message: "本日記録した勤務記録の数が規定値に達していません。支給額に影響を及ぼす可能性があります。本当にこのまま退勤しますか？" ,preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "いいえ", style: .cancel, handler: { (_) in
        return
      }))
      alert.addAction(UIAlertAction(title: "はい", style: .destructive, handler: { _ in
        let alert =  UIAlertController(title: "本当に退勤しますか？", message: "やり忘れていることがないか、もう一度確認しましょう。" ,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "いいえ", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "はい", style: .destructive, handler: { _ in
          self.offWorkNow()
        }))
        self.present(alert, animated: true, completion: nil)
        
      }))
      present(alert, animated: true, completion: nil)
    
    } else {
      let alert =  UIAlertController(title: "本当に退勤しますか？", message: "やり忘れていることがないか、もう一度確認しましょう。" ,preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "いいえ", style: .cancel, handler: nil))
      alert.addAction(UIAlertAction(title: "はい", style: .destructive, handler: { _ in
        self.offWorkNow()
      }))
      present(alert, animated: true, completion: nil)
      
    }
  }
  


}




