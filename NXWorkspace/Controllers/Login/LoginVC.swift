//
//  LoginViewController.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/15.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var companyIDView: UIView!
  @IBOutlet weak var teamMemberView: UIView!
  @IBOutlet weak var passwordEntryView: UIView!
  @IBOutlet weak var passwordEntrySubView: UIView!
  

  
  @IBOutlet weak var companyIDLabel: UILabel!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userImageDiscriptionLabel: UILabel!
  @IBOutlet weak var passwordTextField: UITextField!
  
  var companyID: String?
  var userSelected: User?
  
  
  
  //**************************************************************
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    passwordTextField.delegate = self
    passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    
    if let userSelected = userSelected {
      userImageView.image = UIImage(named: userSelected.lastName_Kanji)
      userImageDiscriptionLabel.text = userSelected.fullName
      userImageDiscriptionLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      passwordTextField.isEnabled = true
      passwordTextField.becomeFirstResponder()
    } else {
      userImageView.image = nil
      userImageDiscriptionLabel.text = Text.pleaseSelectUser
      userImageDiscriptionLabel.textColor = #colorLiteral(red: 0.901956141, green: 0.3706851006, blue: 0.3618388772, alpha: 1)
      passwordTextField.isEnabled = false
      passwordTextField.resignFirstResponder()
    }
  }
  
  @IBAction func companyIDTapped(_ sender: UITapGestureRecognizer) {
    UIView.animate(withDuration: 0.2) {self.companyIDLabel.alpha = 0.5}
    UIView.animate(withDuration: 0.3) {self.companyIDLabel.alpha = 1.0}
    
    performSegue(withIdentifier: "showCompanySelectionSegue", sender: self)
  }
  
  
  @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
    UIView.animate(withDuration: 0.2) {self.userImageView.alpha = 0.5; self.userImageDiscriptionLabel.alpha = 0.5}
    UIView.animate(withDuration: 0.3) {self.userImageView.alpha = 1.0; self.userImageDiscriptionLabel.alpha = 1.0}
    
    performSegue(withIdentifier: "showUserSelectionSegue", sender: self)
  }
  

  
  

  @IBAction func superViewTapped(_ sender: UITapGestureRecognizer) {
    passwordTextField.resignFirstResponder()
    UIView.animate(withDuration: 0.35) {
      self.navigationItem.title = "Workspace"
      self.companyIDView.isHidden = false
      self.companyIDView.alpha = 1.0
    }
  }
  
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    UIView.animate(withDuration: 0.35) {
      self.navigationItem.title = "ログイン"
      self.companyIDView.isHidden = true
      self.companyIDView.alpha = 0.0
    }
    return true
  }
  
  
  @objc func textFieldDidChange() {
    guard let userSelected = userSelected else {return}
    
    if passwordTextField.text == userSelected.password {
      passwordTextField.resignFirstResponder()

      UserDefaults.standard.set(userSelected.documentID, forKey: "userID")
      UserDefaults.standard.set(userSelected.fullName, forKey: "userFullName")
      UserDefaults.standard.set(true, forKey: "hasUserLogedIn")
      
      UIView.animate(withDuration: 0.5) {self.passwordEntrySubView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1); self.passwordTextField.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)}
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {self.dismiss(animated: true, completion: nil)}
      
    } else if passwordTextField.text?.count ?? 0 > 4 {
      UIView.animate(withDuration: 0.5) {self.passwordEntrySubView.backgroundColor = #colorLiteral(red: 0.9408496618, green: 0.4808571339, blue: 0.4975002408, alpha: 1); self.passwordTextField.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)}
      
    } else {
      UIView.animate(withDuration: 0.2) {self.passwordEntrySubView.backgroundColor = #colorLiteral(red: 0.9410838485, green: 0.9412414432, blue: 0.9410631061, alpha: 1); self.passwordTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)}
    }
    
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showUserSelectionSegue" {
      let userSelectionTableViewController = segue.destination as! UserSelectionTableViewController
      userSelectionTableViewController.loginViewController = self
    }
    if segue.identifier == "showCompanySelectionSegue" {
      
    }
    
  }
  
}
