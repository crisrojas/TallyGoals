//
//  BehaviourRow.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 27/05/2022.
//

import SwiftUI
import SwiftUItilities
import SwiftWind
import ComposableArchitecture

struct BehaviourRow: View {
  
  @State var showEditScreen = false
  @State var showDeletingAlert = false
  
  let model: Behaviour
  let archived: Bool
  let viewStore: AppViewStore
 
  init(model: Behaviour, archived: Bool = false, viewStore: AppViewStore) {
    self.model = model
    self.viewStore = viewStore
    self.archived = archived
  }
  
  
  var body: some View {
    
    rowCell
      .background(Color.behaviourRowBackground)
      .navigationLink(editScreen, $showEditScreen)
      .sparkSwipeActions(
        leading: archived ? [] : leadingActions,
        trailing: trailingActions
      )
      .onTap(perform: increase)
      .buttonStyle(.plain)
      .alert(isPresented: $showDeletingAlert) { .deleteAlert(action: delete) }
  }
  
  var rowCell: some View {
    HStack(spacing: 0) {
      
      Text(model.emoji)
        .font(.caption2)
        .grayscale(archived ? 1 : 0)
      
      Text(model.count.string)
        .font(.system(.largeTitle, design: .rounded))
        .fontWeight(.bold)
        .horizontal(.s3)
      
        Text(model.name)
          .fontWeight(.bold)
          .font(.system(.body, design: .rounded))
          .lineLimit(2)
        
        Spacer()
    }
    .horizontal(.horizontal)
    .vertical(.s3)
    .overlay(divider, alignment: .bottomTrailing)
  }
}

// MARK: - SwipeActions
private extension BehaviourRow {
  var leadingActions: [SwipeAction] {
    [
      SwipeAction(
        label: "Épingler",
        systemSymbol: "pin.fill",
        action: pin,
        backgroundColor: .blue500
      ),
      SwipeAction(
        label: "Éditer",
        systemSymbol: "pencil",
        action: goToEditScreen,
        backgroundColor: .lime600
      ),
      SwipeAction(
        label: "Réduir d'une unité",
        systemSymbol: "minus.circle",
        action: decrease,
        backgroundColor: .yellow600
      )
    ]
  }
  
  var trailingActions: [SwipeAction] {
    [
      SwipeAction(
        label: "Effacer",
        systemSymbol: "trash",
        action: showAlert,
        backgroundColor: .red500
      ),
      SwipeAction(
        label: archived ? "Désarchiver" : "Archiver",
        systemSymbol: "archivebox",
        action: archive,
        backgroundColor: .orange400
      )
    ]
  }
}

// MARK: - UI
private extension BehaviourRow {
  var editScreen: some View {
    BehaviourEditScreen(
      viewStore: viewStore,
      item: model,
      emoji: model.emoji,
      name: model.name
    )
  }

  var divider: some View {
    let color = .isDarkMode ? WindColor.gray.c800 : WindColor.gray.c100
    return Rectangle()
      .foregroundColor(color)
      .height(.px)
  }
}

// MARK: - Methods
private extension BehaviourRow {
  
  func increase() {
    vibrate()
    withAnimation {
      guard !archived else { return }
      viewStore.send(.addEntry(behaviour: model.id))
    }
  }
  
  func decrease() {
    guard model.count > 0 else {
      vibrate(.error)
      return
    }
    
    vibrate()
    withAnimation {
      viewStore.send(.deleteEntry(behaviour: model.id))
    }
  }
  
  func goToEditScreen() {
    showEditScreen = true
  }
  
  func pin() {
    viewStore.send(.updatePinned(id: model.id, pinned: true))
  }
  
  func archive() {
    viewStore.send(.updateArchive(id: model.id, archive: !archived))
  }
  
  func delete() {
    viewStore.send(.deleteBehaviour(id: model.id))
  }
  
  func showAlert() {
    showDeletingAlert = true
  }
}
