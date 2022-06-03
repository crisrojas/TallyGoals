//
//  SwipeActions.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 02/06/2022.
//
import SwiftUI
import SwiftUItilities

struct SwipeAction: Identifiable, Equatable {

  let id: UUID = UUID()
  let label: String?
  let systemSymbol: String
  let action: () -> Void
  let backgroundColor: Color
  let tintColor: Color
  
  init(
    label: String?,
    systemSymbol: String,
    action: @escaping () -> Void,
    backgroundColor: Color = .black,
    tintColor: Color = .white
  ) {
    self.label = label
    self.systemSymbol = systemSymbol
    self.action = action
    self.backgroundColor = backgroundColor
    self.tintColor = tintColor
  }
  
  static func == (
    lhs: SwipeAction,
    rhs: SwipeAction
  ) -> Bool {
    lhs.id == rhs.id
  }
}

extension CGFloat {
  static let swipeActionItemWidth = CGFloat.s1 * 18
}

extension View {

  func swipeActions(
    leading: [SwipeAction] = [],
    trailing: [SwipeAction] = []
  ) -> some View {
    
    self.modifier(
      SwipeActionModifier(
        leading: leading,
        trailing: trailing
      )
    )
  }
}

