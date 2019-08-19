//
//  AddNewUserVC.swift
//  
//
//  Created by Zhiren Jin on 2019/08/17.
//

import UIKit
import Firebase

class AddNewUserVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
  @IBOutlet var textFieldCollection: [UITextField]!
  @IBOutlet weak var genderTextField: UITextField!
  @IBOutlet weak var birthdayTextField: UITextField!
  @IBOutlet weak var teamTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  var genderPicker = UIPickerView()
  var teamPicker = UIPickerView()
  var datePicker = UIDatePicker()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
    let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarItemTapped))
    
    toolbar.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    toolbar.setItems([spacelItem, doneItem], animated: true)
    
    genderPicker.delegate = self
    genderPicker.dataSource = self
    teamPicker.delegate = self
    teamPicker.dataSource = self
    datePicker.datePickerMode = .date
    datePicker.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
    genderTextField.inputView = genderPicker
    genderTextField.inputAccessoryView = toolbar
    teamTextField.inputView = teamPicker
    teamTextField.inputAccessoryView = toolbar
    birthdayTextField.inputView = datePicker
    birthdayTextField.inputAccessoryView = toolbar
    
    textFieldCollection.forEach() {$0.delegate = self}
    passwordTextField.addTarget(self, action: #selector(self.passwordFieldDidChange), for: .editingChanged)
  }
  
  //MARK: - Delegate Methods ********************************************
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView.isEqual(genderPicker) { return ["","男性","女性","その他"].count }
    if pickerView.isEqual(teamPicker) { return ["","講師","開発","営業"].count }
    return 0
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView.isEqual(genderPicker) { return ["","男性","女性","その他"][row] }
    if pickerView.isEqual(teamPicker) { return ["","講師","開発","営業"][row] }
    return nil
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView.isEqual(genderPicker) { genderTextField.text = ["","男性","女性","その他"][row] }
    if pickerView.isEqual(teamPicker) { teamTextField.text = ["","講師","開発","営業"][row] }
  }
  
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField.isEqual(passwordTextField) {
      let currentText = textField.text ?? ""
      guard let stringRange = Range(range, in: currentText) else { return false }
      let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
      return updatedText.count <= 4
    } else {
      return true
    }
  }
  

  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let count = textFieldCollection.count
    let index = textFieldCollection.firstIndex(of: textField)!
    let result = textFieldCollection.filter() {$0.text == "" || $0.text == nil}
    
    if result.count == 0 {
      textFieldCollection[index].resignFirstResponder()
    } else if index < (count-1) {
      textFieldCollection[index+1].becomeFirstResponder()
    } else {
      textFieldCollection[index].resignFirstResponder()
    }
    return true
  }
  
  // ********************************************************************
  
  
  //MARK: - User Interactions *******************************************
  
  @IBAction func mainViewTapped(_ sender: UITapGestureRecognizer) {
    textFieldCollection.forEach() {$0.resignFirstResponder()}
  }
  
  @objc func dateValueChanged() {
    birthdayTextField.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: .long, timeStyle: .none)
  }
  
  @objc func passwordFieldDidChange() {
    if (passwordTextField.text ?? "").count > 3 {
      passwordTextField.resignFirstResponder()
    }
  }
  
  @objc func doneBarItemTapped() {
    let count = textFieldCollection.count
    let array = textFieldCollection.filter() {$0.isFirstResponder}
    let index = textFieldCollection.firstIndex(of: array[0])!
    let result = textFieldCollection.filter() {$0.text == "" || $0.text == nil}
    
    if result.count == 0 {
      textFieldCollection[index].resignFirstResponder()
    } else if index < (count-1) {
      textFieldCollection[index+1].becomeFirstResponder()
    } else {
      textFieldCollection[index].resignFirstResponder()
    }
  }
  
  @IBAction func registerButtonTapped(_ sender: UIBarButtonItem) {
    sender.isEnabled = false
    let alert =  UIAlertController(title: "記入漏れがあります", message: "ユーザを登録するには、全ての項目を記入してください",preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    let result = textFieldCollection.filter() {$0.text == "" || $0.text == nil}
    if result.count > 0 {
      present(alert, animated: true, completion: nil)
      sender.isEnabled = true
    } else {
      textFieldCollection.forEach() {$0.isEnabled = false}
      
      let user: [String: Any] = [
        "lastName_Kanji": textFieldCollection[0].text!,
        "lastName_Hiragana": textFieldCollection[1].text!,
        "firstName_Kanji": textFieldCollection[2].text!,
        "firstName_Hiragana": textFieldCollection[3].text!,
        "gender": textFieldCollection[4].text!,
        "birthDay": datePicker.date,
        "affiliatedWith": "LACOMS",
        "team": textFieldCollection[6].text!,
        "password": textFieldCollection[7].text!,
        "createdOn": Date(),
        "updatedOn": Date(),
      ]
      let docReference = Firestore.firestore().collection("company").document("001 - LACOMS").collection("user").addDocument(data: user)
      docReference.updateData(["documentID": docReference.documentID]) { _ in
        self.navigationController?.popViewController(animated: true)
      }
    }
    
  }
  
  

  
  // ********************************************************************
  
  
  //MARK: - Firebase Set Data *******************************************
  
  
  
  
}
