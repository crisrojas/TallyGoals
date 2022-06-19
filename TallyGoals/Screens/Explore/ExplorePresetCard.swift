//
//  ExplorePresetCard.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 19/06/2022.
//

import SwiftUI
import SwiftWind

struct ExplorePresetCard: View {
  
  @State var showDetail = false
  let model: PresetCategory
  let viewStore: AppViewStore
  
  var body: some View {
//    Color.clear
//    .background(.thinMaterial)
    background
    .cornerRadius(.s3)
    .aspectRatio(1, contentMode: .fit)
    .overlay(labelStack)
    .onTap {
      viewStore.send(.setOverlay(overlay: .exploreDetail(model)))
      
    }
    .buttonStyle(.plain)
    .navigationLink(detailScreen, $showDetail)
  }
  
  
  
  var background: some View {
    VerticalLinearGradient(colors: [
      .isDarkMode ? WindColor.zinc.c600 : WindColor.zinc.c100,
      .isDarkMode ? WindColor.zinc.c700 : WindColor.zinc.c200
    ])
  }
  
  var detailScreen: some View {
    PresetCategoryDetailScreen(model: model, viewStore: viewStore)
  }
  
  var labelStack: some View {
    VStack(spacing: .s6) {
      Text(model.emoji)
//      .font(.system(size: .s14))
      .font(.largeTitle)
      Text(model.name)
      .roundedFont(.subheadline)
      .fontWeight(.bold)
      .frame(maxWidth: .s28)
      .multilineTextAlignment(.center)
    }
  }
}
