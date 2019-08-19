//
//  UserSelectionTableViewController.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/15.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

class UserSelectionTableViewController: UITableViewController {
  var loginViewController: LoginViewController!
  
  var teamUsersDictionary = [String: [User]]()
  var teams = [String]()
  
  override func viewWillAppear(_ animated: Bool) {
    loadUserData()
  }
  
  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return teams.count
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return teams[section]
  }
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    header.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    header.textLabel?.textColor = #colorLiteral(red: 0.9058823529, green: 0.3725490196, blue: 0.3607843137, alpha: 1)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return teamUsersDictionary[teams[section]]?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserSelectionCell", for: indexPath) as! UserSelectionCell
    let row = indexPath.row
    let section = indexPath.section

    cell.user = teamUsersDictionary[teams[section]]![row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      loginViewController.userSelected = teamUsersDictionary[teams[indexPath.section]]![indexPath.row]
      tableView.deselectRow(at: indexPath, animated: true)
      navigationController?.popViewController(animated: true)
  }
 
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    performSegue(withIdentifier: "showAddNewUserSegue", sender: self)
  }
  
  

}



extension UserSelectionTableViewController {
  
  func loadUserData() {
    Firestore.firestore().collection("company").document("001 - LACOMS").collection("user").getDocuments { (snapshot, error) in
      guard let snapshot = snapshot else {print(error.debugDescription); return}
      let teamArray = UserDefaults.standard.array(forKey: "teamList") as! [String]
      var userArray = [User]()
      var matrix = [String: [User]]()
      
      for document in snapshot.documents {
        let user = User(data: document.data())
        userArray.append(user)
      }
      
      for team in teamArray {
        matrix[team] = [User]()
      }
      
      for user in userArray {
        matrix[user.team]?.append(user)
      }
      
      self.teamUsersDictionary = matrix
      self.teams = teamArray
      
      self.tableView.reloadData()
    }
  }
}
