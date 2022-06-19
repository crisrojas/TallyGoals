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
          .size(isSelected ? .s1h : .s1)
          .foregroundColor(isSelected ? .white : foregroundColor)
          .animation(.easeInOut, value: isSelected)
      }
    }
    .padding(.s1)
//    .background(background.cornerRadius(999))
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
  
  var foregroundColor: Color {
      WindColor.neutral.c500
  }
}
