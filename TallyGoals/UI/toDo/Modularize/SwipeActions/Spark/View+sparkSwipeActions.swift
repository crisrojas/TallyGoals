//
//  View+sparkSwipeActions.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import SwiftUI

extension View {
  func sparkSwipeActions(
    leading: [SwipeAction] = [],
    trailing: [SwipeAction] = []
  ) -> some View {
    self.modifier(SparkSwipeActionModifier(leading: leading, trailing: trailing))
  }
}
