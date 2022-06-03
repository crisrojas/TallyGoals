//
//  UIImpactFeedbackGenerator.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import UIKit

extension UIImpactFeedbackGenerator {
  
  static var shared: UIImpactFeedbackGenerator {
    UIImpactFeedbackGenerator(style: .medium)
  }
}
