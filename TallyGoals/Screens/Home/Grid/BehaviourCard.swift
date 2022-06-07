//
//  BehaviourCard.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import SwiftUI
import SwiftWind
import SwiftUItilities

struct BehaviourCard: View {
  
  @State var showEditingScreen = false
  @State var showDeletingAlert = false
  
  let model: BehaviourEntity
  let viewStore: AppViewStore

  var body: some View {
      background
      .cornerRadius(.s4)
      .aspectRatio(1, contentMode: .fill)
      .overlay(
        Text(model.emoji ?? "") // @todo
        .font(.caption)
        .padding()
        , alignment: .topTrailing
      )
      .overlay(chevronIcon, alignment: .topLeading)
      .overlay(labelStack, alignment: .bottomLeading)
      .onTapGesture(perform: increase)
      .contextMenu { contextMenuContent }
      .navigationLink(editScreen, $showEditingScreen)
      .alert(isPresented: $showDeletingAlert) { .deleteAlert(action: delete) }
  }
  
  @ViewBuilder
  var contextMenuContent: some View {
    Label("Unpin", systemImage: "pin").onTap(perform: unpin)
    Label("Decrease", systemImage: "minus.circle").onTap(perform: decrease).displayIf(model.entries?.count ?? 0 > 0) // @todo
    Label("Edit", systemImage: "pencil").onTap(perform: goToEditScreen)
    Label("Archive", systemImage: "archivebox").onTap(perform: archive)
    
    Button(role: .destructive) {
      showDeletingAlert = true
    } label: {
      Label("Delete", systemImage: "trash").onTap {}
    }
  }
  
  var chevronIcon: some View {
    Image(systemName: "chevron.right")
    .foregroundColor(WindColor.gray.c400)
    .padding(.s3)
    .displayIf(viewStore.state.isEditingMode)
  }
  
  var labelStack: some View {
    DefaultVStack {
      Text(model.entries?.count.string ?? "") // @todo
        .fontWeight(.bold)
        .font(.system(.title2, design: .rounded))
      Text(model.name ?? "") // @todo
        .fontWeight(.bold)
        .font(.system(.caption, design: .rounded))
        .lineLimit(2)
    }
    .foregroundColor(.isDarkMode ? .white : WindColor.zinc.c700)
    .padding(.s3)
  }
  
  var editScreen: some View {
    BehaviourEditScreen(
      viewStore: viewStore,
      item: model,
      emoji: model.emoji ?? "", // @todo
      name: model.name ?? "" // @todo
    )
  }
  
  @ViewBuilder
  var background: some View {
    VerticalLinearGradient(colors: [
      .isDarkMode ? WindColor.zinc.c600 : WindColor.zinc.c100,
      .isDarkMode ? WindColor.zinc.c700 : WindColor.zinc.c200
    ])
  }
  
  func delete() {
    viewStore.send(.deleteBehaviour(id: model.objectID))
  }
  
  func goToEditScreen() {
    showEditingScreen = true
  }
  
  func archive() {
    viewStore.send(.updateArchive(id: model.objectID, archive: true))
  }
  
  func unpin() {
    viewStore.send(.updatePinned(id: model.objectID, pinned: false))
  }
  
  func decrease() {
    vibrate()
    viewStore.send(.deleteEntry(behaviour: model.objectID))
  }
  
  func increase() {
    vibrate()
    viewStore.send(.addEntry(behaviour: model.objectID))
  }
}
