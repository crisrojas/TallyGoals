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
    HStack {
      Text(model.name)
        .roundedFont(.body)
      Spacer()
      addButton
    }
  }
  
  var addButton: some View {
    Text(added ? "Rajouté".uppercased() : "Rajouter".uppercased())
      .font(.caption)
      .fontWeight(.bold)
      .vertical(.s1h)
      .horizontal(.s3)
      .background(background.cornerRadius(.s60))
      .onTap {
        viewStore.send(
          .createBehaviour(
            id: UUID(),
            emoji: emoji,
            name: model.name
          )
        )
        added = true
      }
      .disabled(added)
      .animation(.spring(), value: added)
  }
  
  @ViewBuilder
  var background: some View {
    .isDarkMode ? WindColor.neutral.c600 : WindColor.neutral.c100
  }
}

