//
//  SwipeActionsView.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 29/05/2022.
//

import SwiftUI
import SwiftWind

struct SwipeActionView: View {
  
  @State var width: CGFloat
  let action: SwipeAction
  let callback: () -> Void
  private var iconOffset: CGFloat { (.swipeActionItemWidth - width) / 2 }
 
  var body: some View {
    return action.backgroundColor
      .overlay(
        Image(systemName: action.systemSymbol)
          .foregroundColor(action.tintColor)
          .bindWidth(to: $width)
          .x(-iconOffset)
        ,
        alignment: .trailing
      )
      .onTap(perform: callback)
      .buttonStyle(.plain)
  }
}
