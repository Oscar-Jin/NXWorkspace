//
//  ViewController.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/14.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
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
  
  
  var timer1: Timer?
  var timer2: Timer?
  var timer3: Timer?
  
  var user: User? {
    didSet {
      nameLabel.text = user?.fullName
      discriptionLabel.text = user?.team
      userImageView.image = UIImage(named: user?.lastName_Kanji ?? "failsafe")
    }
  }
  
  var kintai: Kintai? {
    didSet {
      timer2?.invalidate()
      timer3?.invalidate()
      
      totalWorkTimeLabel.text = "勤務時間： "
      attendanceTimeLabel.text = "出勤時間： "
      offworkTimeLabel.text = "退勤時間： "
      restTimeLabel.text = "休憩時間： "
      
      if let attendedAt = kintai?.attendedAt, let restStartsAt = kintai?.restStartsAt, let restEndsAt = kintai?.restEndsAt, let offworkAt = kintai?.offworkAt {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.second], from: attendedAt, to: offworkAt)
        let components2 = calendar.dateComponents([.second], from: restStartsAt, to: restEndsAt)
        let components3 = calendar.dateComponents([.hour, .minute], from: restStartsAt, to: restEndsAt)
        
        let difference = components1.second! - components2.second!
        let (h,m,_) = self.secondsToHoursMinutesSeconds(seconds: difference)
        totalWorkTimeLabel.text = "勤務時間： " + String(h) + ":" + (String(m).count == 1 ? "0\(m)" : String(m))
        attendanceTimeLabel.text = "出勤時間： " + DateFormatter.localizedString(from: attendedAt, dateStyle: .none, timeStyle: .medium)
        offworkTimeLabel.text = "退勤時間： " + DateFormatter.localizedString(from: offworkAt, dateStyle: .none, timeStyle: .medium)
        restTimeLabel.text = "休憩時間： " + String(components3.hour!) + ":" + (String(components3.minute!).count == 1 ? "0\(components3.minute!)" : "\(components3.minute!)")
        
      } else if let attendedAt = kintai?.attendedAt, let restStartsAt = kintai?.restStartsAt, let restEndsAt = kintai?.restEndsAt {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: restStartsAt, to: restEndsAt)
        restTimeLabel.text = "休憩時間： " + String(components.hour!) + ":" + (String(components.minute!).count == 1 ? "0\(components.minute!)" : "\(components.minute!)")
        attendanceTimeLabel.text = "出勤時間： " + DateFormatter.localizedString(from: attendedAt, dateStyle: .none, timeStyle: .medium)
        
        timer2 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
          let calendar = Calendar.current
          let components1 = calendar.dateComponents([.second], from: attendedAt, to: Date())
          let components2 = calendar.dateComponents([.second], from: restStartsAt, to: restEndsAt)
          let difference = components1.second! - components2.second!
          let (h,m,_) = self.secondsToHoursMinutesSeconds(seconds: difference)
          self.totalWorkTimeLabel.text = "勤務時間： " + String(h) + ":" + (String(m).count == 1 ? "0\(m)" : String(m))
        })
        
      } else if let attendedAt = kintai?.attendedAt, let restStartsAt = kintai?.restStartsAt {
        attendanceTimeLabel.text = "出勤時間： " + DateFormatter.localizedString(from: attendedAt, dateStyle: .none, timeStyle: .medium)
        timer3 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
          let calendar = Calendar.current
          let components = calendar.dateComponents([.hour, .minute], from: restStartsAt, to: Date())
          let components2 = calendar.dateComponents([.hour, .minute], from: attendedAt, to: restStartsAt)
          self.restTimeLabel.text = "休憩時間： " + String(components.hour!) + ":" + (String(components.minute!).count == 1 ? "0\(components.minute!)" : "\(components.minute!)")
          self.totalWorkTimeLabel.text = "勤務時間： " + String(components2.hour!) + ":" + (String(components2.minute!).count == 1 ? "0\(components2.minute!)" : "\(components2.minute!)")
        })
      
      } else if let attendedAt = kintai?.attendedAt, let offworkAt = kintai?.offworkAt {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: attendedAt, to: offworkAt)
        totalWorkTimeLabel.text = "勤務時間： " + String(components.hour!) + ":" + (String(components.minute!).count == 1 ? "0\(components.minute!)" : "\(components.minute!)")
        attendanceTimeLabel.text = "出勤時間： " + DateFormatter.localizedString(from: attendedAt, dateStyle: .none, timeStyle: .medium)
        offworkTimeLabel.text = "退勤時間： " + DateFormatter.localizedString(from: offworkAt, dateStyle: .none, timeStyle: .medium)
      
      } else if let attendedAt = kintai?.attendedAt {
        attendanceTimeLabel.text = "出勤時間： " + DateFormatter.localizedString(from: attendedAt, dateStyle: .none, timeStyle: .medium)
        timer2 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
          let calendar = Calendar.current
          let components = calendar.dateComponents([.hour, .minute], from: attendedAt, to: Date())
          self.totalWorkTimeLabel.text = "勤務時間： " + String(components.hour!) + ":" + (String(components.minute!).count == 1 ? "0\(components.minute!)" : "\(components.minute!)")
        })
      }
      
      
      if kintai != nil {
        print("switching...")
        switch self.kintai!.status {
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
    startTimer()
    
    user = nil
    kintai = nil
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    checkHasUserLogedIn()
  }
  
  
  //MARK: - User Interactions *******************************************
  
  @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
    UserDefaults.standard.set(false, forKey: "hasUserLogedIn")
    user = nil
    kintai = nil
    checkHasUserLogedIn()
  }
  
  @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
    performSegue(withIdentifier: "showTalkViewSegue", sender: self)
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
    let alert =  UIAlertController(title: "本当に退勤されますか？", message: "やり忘れていることがないか、もう一度確認しましょう。" ,preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "いいえ", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "はい", style: .destructive, handler: { _ in
      self.offWorkNow()
    }))
    present(alert, animated: true, completion: nil)
    
  }
  
  
  
}






//MARK: - Internal Logics ***********************************************

extension HomeViewController {
  
  func checkHasUserLogedIn() {
    let hasLogedIn = UserDefaults.standard.bool(forKey: "hasUserLogedIn")
    
    if hasLogedIn {
      view.isHidden = false
      
      currentUserFromFirestore()
      currentKintaiFromFirestore()
    } else {
      view.isHidden = true
      
      user = nil
      kintai = nil
      performSegue(withIdentifier: "showLoginViewSegue", sender: self)
    }
    
  }
  
  func currentUserFromFirestore() {
    guard let userID = UserDefaults.standard.string(forKey: "userID") else {return}
    
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("user").whereField("documentID", isEqualTo: userID).getDocuments { (snapshot, error) in
      guard let document = snapshot?.documents.first else { UserDefaults.standard.set(false, forKey: "hasUserLogedIn"); return}
      self.user = User(data: document.data())
    }
  }
  
  func currentKintaiFromFirestore() {
    guard let userFullName = UserDefaults.standard.string(forKey: "userFullName") else {return}
    let year = String(Calendar.current.component(.year, from: Date()))
    let month = String(Calendar.current.component(.month, from: Date()))
    let day = String(Calendar.current.component(.day, from: Date()))
    let today = year + "_" + month + "_" + day
    
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("timecard").document(today).getDocument { (snapshot, error) in
      guard let snapshot = snapshot else {return}
      guard let kintaiData = snapshot.data()?[userFullName] as? [String: Timestamp] else {return}
      
      self.kintai = Kintai(data: kintaiData)
      
    }
  }
  
  func attendedNow() {
    guard let userFullName = UserDefaults.standard.string(forKey: "userFullName") else {return}

    let year = String(Calendar.current.component(.year, from: Date()))
    let month = String(Calendar.current.component(.month, from: Date()))
    let day = String(Calendar.current.component(.day, from: Date()))
    let today = year + "_" + month + "_" + day
    
    var data = [String: Date]()
    if let attendedAt = kintai?.attendedAt {data["出勤"] = attendedAt }
    if let restStartsAt  = kintai?.restStartsAt {data["休憩"] = restStartsAt }
    if let restEndsAt = kintai?.restEndsAt {data["再開"] = restEndsAt }
    if let offworkAt = kintai?.offworkAt {data["退勤"] = offworkAt }
    
    data["出勤"] = Date()
    kintai = Kintai(data: data)
    
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("timecard").document(today).getDocument { (snapshot, error) in
      guard let _ = error else {return}
      if let _ = snapshot?.data() {
        return
      } else {
        Firestore.firestore().collection("company").document("001 - LACOMS").collection("timecard").document(today).setData([userFullName: data])
      }
    }
    
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("timecard").document(today).updateData([userFullName: data])
  }
  
  func offWorkNow() {
    guard let userFullName = UserDefaults.standard.string(forKey: "userFullName") else {return}
    
    let year = String(Calendar.current.component(.year, from: Date()))
    let month = String(Calendar.current.component(.month, from: Date()))
    let day = String(Calendar.current.component(.day, from: Date()))
    let today = year + "_" + month + "_" + day
    
    var data = [String: Date]()
    if let attendedAt = kintai?.attendedAt {data["出勤"] = attendedAt }
    if let restStartsAt  = kintai?.restStartsAt {data["休憩"] = restStartsAt }
    if let restEndsAt = kintai?.restEndsAt {data["再開"] = restEndsAt }
    if let offworkAt = kintai?.offworkAt {data["退勤"] = offworkAt }
    
    data["退勤"] = Date()
    kintai = Kintai(data: data)
    
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("timecard").document(today).updateData([userFullName: data])
  }
  
  func restStartNow() {
    guard let userFullName = UserDefaults.standard.string(forKey: "userFullName") else {return}
    
    let year = String(Calendar.current.component(.year, from: Date()))
    let month = String(Calendar.current.component(.month, from: Date()))
    let day = String(Calendar.current.component(.day, from: Date()))
    let today = year + "_" + month + "_" + day
    
    var data = [String: Date]()
    if let attendedAt = kintai?.attendedAt {data["出勤"] = attendedAt }
    if let restStartsAt  = kintai?.restStartsAt {data["休憩"] = restStartsAt }
    if let restEndsAt = kintai?.restEndsAt {data["再開"] = restEndsAt }
    if let offworkAt = kintai?.offworkAt {data["退勤"] = offworkAt }
    
    data["休憩"] = Date()
    kintai = Kintai(data: data)
    
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("timecard").document(today).updateData([userFullName: data])
  }
  
  func restEndsNow() {
    guard let userFullName = UserDefaults.standard.string(forKey: "userFullName") else {return}
    
    let year = String(Calendar.current.component(.year, from: Date()))
    let month = String(Calendar.current.component(.month, from: Date()))
    let day = String(Calendar.current.component(.day, from: Date()))
    let today = year + "_" + month + "_" + day
    
    var data = [String: Date]()
    if let attendedAt = kintai?.attendedAt {data["出勤"] = attendedAt }
    if let restStartsAt  = kintai?.restStartsAt {data["休憩"] = restStartsAt }
    if let restEndsAt = kintai?.restEndsAt {data["再開"] = restEndsAt }
    if let offworkAt = kintai?.offworkAt {data["退勤"] = offworkAt }
    
    data["再開"] = Date()
    kintai = Kintai(data: data)
    
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("timecard").document(today).updateData([userFullName: data])
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
  
  func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
  }
  
  
}



