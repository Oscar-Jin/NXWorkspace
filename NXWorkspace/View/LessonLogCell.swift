//
//  ClassRecordCell.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/19.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit

class LessonLogCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

  @IBOutlet weak var timeframeTextField: UITextField!
  @IBOutlet weak var classLevelTextField: UITextField!
  @IBOutlet weak var attendanceNumberTextField: UITextField!
  @IBOutlet weak var talkTextField: UITextField!
  
  var timeframePicker = UIPickerView()
  var classPicker = UIPickerView()
  var numberPicker = UIPickerView()
  
  var lessonLog: LessonLog! {
    didSet {
      timeframeTextField.text = lessonLog.timeframe
      classLevelTextField.text = lessonLog.classLevel
      attendanceNumberTextField.text = lessonLog.attendanceNumber
      talkTextField.text = lessonLog.talk
    }
  }
  
  override func awakeFromNib() {
    timeframeTextField.inputView = timeframePicker
    classLevelTextField.inputView = classPicker
    attendanceNumberTextField.inputView = numberPicker

    [timeframePicker, classPicker, numberPicker].forEach() {
      $0.delegate = self
      $0.dataSource = self
    }
    [timeframeTextField, classLevelTextField, attendanceNumberTextField, talkTextField].forEach() {$0?.delegate = self}
    
    timeframeTextField.addTarget(self, action: #selector(self.timeframeTextFieldDidChange), for: .editingChanged)
    classLevelTextField.addTarget(self, action: #selector(self.classLevelTextFieldDidChange), for: .editingChanged)
    attendanceNumberTextField.addTarget(self, action: #selector(self.attendanceNumberTextFieldDidChange), for: .editingChanged)
    talkTextField.addTarget(self, action: #selector(self.talkTextFieldEditingDidEnd), for: .editingDidEnd)
  }
  
  
  
  //MARK: -Picker View *****************************************
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView.isEqual(timeframePicker) {return Timeframe.selectionItems.count }
    if pickerView.isEqual(classPicker) {return Class.selectionItems_Compact.count }
    if pickerView.isEqual(numberPicker) {return Number.selectionItems.count }
    
    return 0
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView.isEqual(timeframePicker) {return Timeframe.selectionItems[row] }
    if pickerView.isEqual(classPicker) {return Class.selectionItems_Compact[row] }
    if pickerView.isEqual(numberPicker) {return Number.selectionItems[row] }
    
    return nil
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView.isEqual(timeframePicker) {
      timeframeTextField.text = Timeframe.selectionItems[row]
      timeframeTextFieldDidChange()
    }
    if pickerView.isEqual(classPicker) {
      if Class.selectionItems_Compact[row] == Class.事務 || Class.selectionItems_Compact[row] == Class.開発 {
        attendanceNumberTextField.text = "0"
        attendanceNumberTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        attendanceNumberTextField.isEnabled = false
        attendanceNumberTextFieldDidChange()
      } else  {
        attendanceNumberTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        attendanceNumberTextField.isEnabled = true
      }
      classLevelTextField.text =  Class.selectionItems_Compact[row]
      classLevelTextFieldDidChange()
    }
    if pickerView.isEqual(numberPicker) {
      attendanceNumberTextField.text = Number.selectionItems[row]
      attendanceNumberTextFieldDidChange()
    }
  }
  
  
  
  //MARK: -TextField View **************************************
  @objc func timeframeTextFieldDidChange() {
    guard let text = timeframeTextField.text else {return }
    if Timeframe.selectionItems.firstIndex(of: text) == nil {
      timeframeTextField.backgroundColor = #colorLiteral(red: 0.9408496618, green: 0.4808571339, blue: 0.4975002408, alpha: 1)
    } else {
      timeframeTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    lessonLog.timeframe = timeframeTextField.text
  }
  
  @objc func classLevelTextFieldDidChange() {
    guard let text = classLevelTextField.text else {return }
    if Class.selectionItems_Compact.firstIndex(of: text) == nil {
      classLevelTextField.backgroundColor = #colorLiteral(red: 0.9408496618, green: 0.4808571339, blue: 0.4975002408, alpha: 1)
    } else {
      classLevelTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    lessonLog.classLevel = classLevelTextField.text
  }
  
  @objc func attendanceNumberTextFieldDidChange() {
    guard let text = attendanceNumberTextField.text else {return }
    if Number.selectionItems.firstIndex(of: text) == nil {
      attendanceNumberTextField.backgroundColor = #colorLiteral(red: 0.9408496618, green: 0.4808571339, blue: 0.4975002408, alpha: 1)
    } else {
      attendanceNumberTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    lessonLog.attendanceNumber = attendanceNumberTextField.text
  }
  
  @objc func talkTextFieldEditingDidEnd() {
    lessonLog.talk = talkTextField.text
  }
  
  
  
  //MARK: -User Actions ****************************************
  
  @objc func doneBarItemTapped() {
    resignAllFirstResponders()
  }
  
  
  //MARK: -Helper Methods **************************************
  
  func resignAllFirstResponders() {
    timeframeTextField.resignFirstResponder()
    classLevelTextField.resignFirstResponder()
    attendanceNumberTextField.resignFirstResponder()
    talkTextField.resignFirstResponder()
  }

}
