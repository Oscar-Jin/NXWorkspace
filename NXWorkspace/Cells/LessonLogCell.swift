//
//  ClassRecordCell.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/19.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit

class LessonLogCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

  
  @IBOutlet weak var timeframeTextField: UITextField!
  @IBOutlet weak var classLevelTextField: UITextField!
  @IBOutlet weak var attendanceNumberTextField: UITextField!
  @IBOutlet weak var talkTextField: UITextField!
  
  var timeframePicker = UIPickerView()
  var classPicker = UIPickerView()
  var numberPicker = UIPickerView()
  var toolbar: UIToolbar!
  
  override func awakeFromNib() {
    print("AnyawakeFromNib")
    let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarItemTapped))
    
    toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 35))
    toolbar.setItems([spacelItem, doneItem], animated: true)
    toolbar.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    
    timeframeTextField.inputView = timeframePicker
    classLevelTextField.inputView = classPicker
    attendanceNumberTextField.inputView = numberPicker
    
    [timeframePicker, classPicker, numberPicker].forEach() {$0.delegate = self; $0.dataSource = self}
    [timeframeTextField, classLevelTextField, attendanceNumberTextField].forEach() {$0.inputAccessoryView = toolbar}
  }
  
  
  
  //MARK: - Picker View *****************************************
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView.isEqual(timeframePicker) {return Timeframe.selectionItems.count }
    if pickerView.isEqual(classPicker) {return Class.selectionItems.count }
    if pickerView.isEqual(numberPicker) {return Number.selectionItems.count }
    
    return 0
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView.isEqual(timeframePicker) {return Timeframe.selectionItems[row] }
    if pickerView.isEqual(classPicker) {return Class.selectionItems[row] }
    if pickerView.isEqual(numberPicker) {return Number.selectionItems[row] }
    
    return nil
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView.isEqual(timeframePicker) {timeframeTextField.text = Timeframe.selectionItems[row] }
    if pickerView.isEqual(classPicker) {classLevelTextField.text =  Class.selectionItems[row] }
    if pickerView.isEqual(numberPicker) {attendanceNumberTextField.text = Number.selectionItems[row] }
  }
  
  
  
  @objc func doneBarItemTapped() {
    resignAllFirstResponders()
  }
  
  
  
  
  
  
  func resignAllFirstResponders() {
    timeframeTextField.resignFirstResponder()
    classLevelTextField.resignFirstResponder()
    attendanceNumberTextField.resignFirstResponder()
    talkTextField.resignFirstResponder()
  }

}
