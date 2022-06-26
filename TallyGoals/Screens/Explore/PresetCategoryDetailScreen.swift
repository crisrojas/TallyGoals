//
//  PresetCategoryDetailScreen.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 19/06/2022.
//

import SwiftUI
import SwiftUItilities

struct PresetCategoryDetailScreen: View {
  
  let model: PresetCategory
  let viewStore: AppViewStore
  
  var body: some View {
    VStack {
      Text(model.emoji)
        .top(.s6)
        .font(.largeTitle)
      Text(model.name)
        .roundedFont(.title2)
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        .top(.s2)
      
      DefaultVStack {
        ForEach(model.presets) { preset in
          PresetRow(
            emoji: model.emoji,
            model: preset,
            viewStore: viewStore
          )
          .padding(.s3)
        }
      }
      .horizontal(.horizontal)
    }
    .scrollify()
    .overlay(
      Image(systemName: "xmark.circle.fill")
        .resizable()
        .size(.s5)
        .onTap {
          viewStore.send(.setOverlay(overlay: nil))
        }
        .buttonStyle(.plain)
        .padding(.s4)
      ,alignment: .topTrailing
    )
    .background(
      Color.clear.background(.thinMaterial)
    )
  }
}
