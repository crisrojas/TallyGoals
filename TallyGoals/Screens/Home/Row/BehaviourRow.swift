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
  
  let model: BehaviourEntity
  let viewStore: AppViewStore
  
  var body: some View {
    
    rowCell
      .background(Color.behaviourRowBackground)
      .navigationLink(editScreen, $showEditScreen)
      .sparkSwipeActions(leading: leadingActions, trailing: trailingActions)
      .onTapGesture(perform: increase)
      .alert(isPresented: $showDeletingAlert) { .deleteAlert(action: delete) }
  }
  
  var rowCell: some View {
    HStack(spacing: 0) {
       
      Text(model.emoji ?? "") // @todo
        .font(.caption2)
      
      Text(model.entries?.count.string ?? "0") // @todo
        .font(.system(.largeTitle, design: .rounded))
        .fontWeight(.bold)
        .horizontal(.s3)
      
        Text(model.name ?? "") //@todo
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
        label: "Anclar",
        systemSymbol: "pin.fill",
        action: pin,
        backgroundColor: .blue500
      ),
      SwipeAction(
        label: "Editar",
        systemSymbol: "pencil",
        action: goToEditScreen,
        backgroundColor: .lime600
      ),
      SwipeAction(
        label: "Reducir una unidad",
        systemSymbol: "minus.circle",
        action: decrease,
        backgroundColor: .yellow600
      )
    ]
  }
  
  var trailingActions: [SwipeAction] {
    [
      SwipeAction(
        label: "Borrar",
        systemSymbol: "trash",
        action: delete,
        backgroundColor: .red500
      ),
      SwipeAction(
        label: "Archivar",
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
      emoji: model.emoji!,
      name: model.name!,
      count: model.entries?.count ?? 0
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
      viewStore.send(.addEntry(behaviour: model.objectID))
    }
  }
  
  func decrease() {
    guard model.entries?.count ?? 0 > 0 else {
      vibrate(.error)
      return
    }
    
    vibrate()
    withAnimation {
      viewStore.send(.deleteEntry(behaviour: model.objectID))
    }
  }
  
  func goToEditScreen() {
    showEditScreen = true
  }
  
  func pin() {
    viewStore.send(.updatePinned(id: model.objectID, pinned: true))
  }
  
  func archive() {
    viewStore.send(.updateArchive(id: model.objectID, archive: true))
  }
  
  func delete() {
    showDeletingAlert = true
  }
}
