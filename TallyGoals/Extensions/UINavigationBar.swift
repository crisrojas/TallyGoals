//
//  UINavigationBar.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//
import UIKit

extension UINavigationBar {
  static func setupFonts() {
    var largeTitleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
    let largeTitleDescriptor = largeTitleFont.fontDescriptor.withDesign(.rounded)?
    .withSymbolicTraits(.traitBold)
    
    largeTitleFont = UIFont(descriptor: largeTitleDescriptor!, size: largeTitleFont.pointSize)
    
    var inlineFont = UIFont.preferredFont(forTextStyle: .body)
    let inlineDescriptor = inlineFont.fontDescriptor.withDesign(.rounded)?
      .withSymbolicTraits(.traitBold)
    
    inlineFont = UIFont(descriptor: inlineDescriptor!, size: inlineFont.pointSize)
    
    UINavigationBar.appearance().largeTitleTextAttributes = [.font : largeTitleFont]
    UINavigationBar.appearance().titleTextAttributes = [.font: inlineFont]
  }
}
