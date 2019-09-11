//
//  CompanySelectionViewController.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/16.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

class CompanySelectionViewController: UITableViewController {
  var companyNameArray = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    
    Firestore.firestore().collection("company").getDocuments { (snapshot, error) in
      guard let snapshot = snapshot else {return}
      self.companyNameArray = snapshot.documents.map() {$0.documentID}
      self.tableView.reloadData()
    }
  
  }
  

  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {return 1}
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return companyNameArray.count}
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CompanySelectionCell", for: indexPath) as! CompanySelectionCell
    
    cell.companyName = companyNameArray[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    navigationController?.popViewController(animated: true)
  }
  
}
