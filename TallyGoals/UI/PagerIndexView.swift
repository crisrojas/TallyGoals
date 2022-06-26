//
//  PagerIndexView.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import SwiftUI
import SwiftWind

struct PagerIndexView: View {
  
  let currentIndex: Int
  let maxIndex: Int
  
  var body: some View {
    HStack {
      ForEach(0...maxIndex) { index in
        let isSelected = currentIndex == index
        Circle()
          .size(.s1)
          .foregroundColor(foreground(isSelected: isSelected))
          .animation(.easeInOut, value: isSelected)
      }
    }
    .padding(.s1)
    .animation(.easeInOut, value: maxIndex)
  }
  
  @ViewBuilder
  var background: some View {
    if .isDarkMode {
      WindColor.neutral.c500
    } else {
      WindColor.neutral.c300
    }
  }
  
  func foreground(isSelected: Bool) -> Color {
    if isSelected {
      return WindColor.neutral.c500
    } else {
      return WindColor.neutral.c200
    }
  }
}
