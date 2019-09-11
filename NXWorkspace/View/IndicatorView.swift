//
//  IndicatorView.swift
//  NXWorkspace
//
//  Created by Zhiren Jin on 2019/08/24.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit

class IndicatorView {
  var vSpinner: UIView?
  
  func showSpinner() {
    let spinnerView = UIView.init(frame: UIApplication.shared.keyWindow!.frame)
    spinnerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    spinnerView.alpha = 0.3
    
    let indicator = UIActivityIndicatorView.init(style: .whiteLarge)
    indicator.center = spinnerView.center
    indicator.startAnimating()
    
    DispatchQueue.main.async {
      spinnerView.addSubview(indicator)
      UIApplication.shared.keyWindow?.addSubview(spinnerView)
    }
    
    vSpinner = spinnerView
  }
  
  func removeSpinner() {
    DispatchQueue.main.async {
      self.vSpinner?.removeFromSuperview()
      self.vSpinner = nil
    }
  }
}
