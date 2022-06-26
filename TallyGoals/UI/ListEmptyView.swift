//
//  ListEmptyView.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 26/06/2022.
//

import SwiftUI
struct ListEmptyView: View {
  
  let symbol: String
  
  var body: some View {
    Image(systemName: symbol)
      .resizable()
      .width(50)
      .height(40)
      .foregroundColor(.gray)
      .opacity(0.2)
  }
}
