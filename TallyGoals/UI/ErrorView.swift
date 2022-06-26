//
//  ErrorView.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 26/06/2022.
//

import SwiftUI
import SwiftUItilities

struct ErrorView: View {
  
  let title: String
  let message: String
  let viewStore: AppViewStore
  
  var body: some View {
    VStack(spacing: 0) {
      Text(title)
        .roundedFont(.body)
        .bold()
      
      Text(message)
      .top(.s1)
      
      Text("Ok")
        .onTap {
          viewStore.send(.setOverlay(overlay: nil))
        }
      .top(.s1)
    }
    .padding()
    .width(.s48)
    .cornerRadius(.s6)
    .background(.thinMaterial)
    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
  }
}
