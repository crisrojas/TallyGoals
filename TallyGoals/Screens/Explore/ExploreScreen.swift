//
//  ExploreScreen.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 13/06/2022.
//

import SwiftUI
import SwiftUItilities
import SwiftWind




struct ExploreScreen: View {
  @State var showDetail = false
  @GestureState var isPressed = false
  
  @Namespace var namespace
  let viewStore: AppViewStore
  
  
  private let columns = [
    GridItem(.flexible(), spacing: .s4),
    GridItem(.flexible(), spacing: .s4)
  ]
  
  let feauredModel = presetsCategories.map { presetCategory in
    return (presetCategory, presetCategory.presets.filter { $0.isFeatured })
  }
  
  var body: some View {
      DefaultVStack {
        
        LazyVGrid(columns: columns, spacing: .s4) {
          
          ForEach(presetsCategories) { category in
            ExplorePresetCard(model: category, viewStore: viewStore)
          }
        }
      }
      .horizontal(.s4)
      .vertical(.s6)
      .scrollify()
  }
}
