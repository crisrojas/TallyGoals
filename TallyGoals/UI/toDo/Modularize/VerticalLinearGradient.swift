//
//  VerticalLinearGradient.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import SwiftUI

// @todo: Move to SwiftUItilities module
struct VerticalLinearGradient: View {
  let colors: [Color]
  var body: some View {
    LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
  }
}
