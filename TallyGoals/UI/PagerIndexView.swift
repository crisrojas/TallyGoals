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
          .size(.s2)
          .foregroundColor(isSelected ? .white : foregroundColor)
          .animation(.easeInOut, value: isSelected)
      }
    }
    .padding(.s2)
    .background(background.cornerRadius(999))
    .animation(.easeInOut, value: maxIndex)
  }
  
  @ViewBuilder
  var background: some View {
    if .isDarkMode {
      WindColor.neutral.c500
    } else {
      WindColor.neutral.c200
    }
  }
  
  var foregroundColor: Color {
      WindColor.neutral.c400
  }
}
