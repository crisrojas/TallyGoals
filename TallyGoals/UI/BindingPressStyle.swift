//
//  BindingPressStyle.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 19/06/2022.
//

import SwiftUI

struct BindingPressStyle: ButtonStyle {
  
  @Binding var isPressed: Bool
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .onChange(of: configuration.isPressed) { newValue in
        isPressed = newValue
      }
  }
}
