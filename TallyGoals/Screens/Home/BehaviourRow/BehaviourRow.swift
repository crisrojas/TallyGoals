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
  
  @State var count: Int = 0
  @State var offset: CGFloat = .zero
  
  @State var showEditScreen = false
  @State var isDecreaseMode = false
  @State var isCountShaking: Bool = false
  
  /// @todo: this should take only the model.id?
  let model: Behaviour
  let viewStore: AppViewStore
  
  var body: some View {
    
    row()
      .background(dynamicBackground)
      .simultaneusLongGesture(perform: toggleDecreaseMode)
      .highPriorityTapGesture(perform: highPriorityAction)
      .navigationLink(editScreen, $showEditScreen)
      .behaviourRowSwipeActions(
        offset: $offset,
        isEditing: $isDecreaseMode,
        viewStore: viewStore,
        background: dynamicBackground,
        model: model
      )
      /// @todo: use TCA state
      .onReceive(NotificationCenter.collapseRowNotification) { _ in
        stopDecreaseMode()
        resetOffsetIfNeeded()
      }
  }
  
  func row() -> some View {
    HStack(spacing: 0) {
      
      Text(model.emoji)
        .font(.caption2)
      
      Text(count.string)
        .font(.system(.largeTitle, design: .rounded))
        .fontWeight(.bold)
        .modifier(ShakeEffect(animatableData: CGFloat(self.isCountShaking ? 1 : 0)))
        .x(-.s2) // Needed because ShakeEffect
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

// MARK: - UI
extension BehaviourRow {
  var editScreen: some View {
    BehaviourEditScreen(
      viewStore: viewStore,
      item: model,
      emoji: model.emoji,
      name: model.name,
      count: model.count
    )
  }

  var dynamicBackground: Color {
    if isDecreaseMode {
      return decreaseModeBackground
    } else {
      return Color.behaviourRowBackground
    }
  }
  
  var decreaseModeBackground: Color {
    if .isDarkMode {
     return Color.itemEditingColor.c500
    } else {
      return Color.itemEditingColor.c100
    }
  }
  
  var divider: some View {
    let color = .isDarkMode ? WindColor.gray.c800 : WindColor.gray.c100
    return Rectangle()
      .foregroundColor(isDecreaseMode ? .clear : color)
      .height(.px)
  }
}

// MARK: - Methods
extension BehaviourRow {
  
  func stopDecreaseMode() {
    isDecreaseMode = false
  }
  
  func toggleDecreaseMode() {
    isDecreaseMode.toggle()
    resetOffsetIfNeeded()
  }
  
  /// Resets the custom swipe actions offset
  func resetOffsetIfNeeded() {
    guard offset != 0 else { return }
    withAnimation { offset = 0 }
  }
  
  func increase() {
    vibrate()
    withAnimation { count += 1 }
  }
  
  func decrease() {
    guard count > 0 else {
      vibrate(.error)
      withAnimation { shakeCount() }
      return
    }
    
    vibrate()
    withAnimation { count -= 1 }
  }
  
  func shakeCount() {
    isCountShaking.toggle()
  }
 
  func highPriorityAction() {
    
    guard viewStore.swipingBehaviourId == nil else {
      viewStore.send(.startSwipe(id: nil))
      return
    }
    
    guard offset == 0 else {
      resetOffsetIfNeeded()
      return
    }
    
    /// Otherwise continue...
    updateCount()
  }
  
  func updateCount() {
    if isDecreaseMode {
      decrease()
    } else {
      increase()
    }
  }
}
