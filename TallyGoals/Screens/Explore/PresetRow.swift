//
//  PresetRow.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 19/06/2022.
//

import SwiftUI
import SwiftWind

struct PresetRow: View {
  
  @State var added: Bool = false
  
  let emoji: String
  let model: Preset
  let viewStore: AppViewStore
  
  var body: some View {
    Text(added ? "Added".uppercased() : "Add".uppercased())
      .font(.caption)
      .fontWeight(.bold)
      .vertical(.s1h)
      .horizontal(.s3)
      .background(background.cornerRadius(.s60))
      .onTap {
        viewStore.send(.createBehaviour(emoji: emoji, name: model.name, completion: addedCompletion))
      }
      .disabled(added)
      .animation(.spring(), value: added)
  }
  
  func addedCompletion() {
    added = true
  }
  
  @ViewBuilder
  var background: some View {
    .isDarkMode ? WindColor.neutral.c600 : WindColor.neutral.c100
  }
}

