//
//  SwipeActionModifier.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import SwiftUI
import Combine
import SwiftUItilities

struct SwipeActionModifier: ViewModifier {
  
  @State var offset = CGFloat.zero
  
  private let id = UUID()
  let leading: [SwipeAction]
  let trailing: [SwipeAction]
 
  /// Sends current item id to the manager
  /// This allows to collapse all the non-current row actions
  func sink() {
    SwipeManager.shared.$swipingId.dropFirst().sink { swipingId in
      guard let swipingId = swipingId else {
        resetOffset()
//        SwipeManager.shared.collapse()
        return
      }
      if id != swipingId {
        resetOffset()
      }
    }
    .store(in: &SwipeManager.shared.cancellables)
    
    SwipeManager.shared.$rowIsOpened.dropFirst().sink { isOpened in
      if !isOpened {
        resetOffset()
      }
    }
    .store(in: &SwipeManager.shared.cancellables)
  }
  
  func body(content: Content) -> some View {
    
    content
      .onAppear(perform: sink)
      .background(content)
      .x(offset)
      .background(actions)
      .simultaneousGesture(
        DragGesture()
          .onChanged(onChangedEvent)
          .onEnded(onEndedEvent)
      )
  }
  
  var actions: some View {
    DefaultHStack {
      
      leadingActions
      trailingActions
    }
  }
  
  var totalLeadingWidth: CGFloat {
      .swipeActionItemWidth * leading.count
  }
  
  var leadingActions: some View {
   ZStack(alignment: .leading) {
      ForEach(leading.reversed().indices) { index in
        let action = leading.reversed()[index]
        let realIndex = leading.firstIndex(of: action)!
        let factor = (realIndex + 1).cgFloat
        let width = .swipeActionItemWidth * factor
        let dynamicWidth = offset / leading.count * factor
        let maxWidth = dynamicWidth < width ? dynamicWidth : width
        let shouldExpand = offset > totalLeadingWidth && realIndex == 0
        
        let callback = {
          action.action()
          resetOffset()
        }
        
        SwipeActionView(
          width: maxWidth,
          action: action,
          callback: callback
        )
        .width(shouldExpand ? totalLeadingWidth : maxWidth)
      }
    }
    .alignX(.leading)
    .displayIf(leading.isNotEmpty)
  }
  
  func actionView(_ action: SwipeAction, width: CGFloat) -> some View {
    let iconWidth = CGFloat.s4
    let iconOffset = (.swipeActionItemWidth - iconWidth) / 2
    return action.backgroundColor
      .overlay(
        Image(systemName: "action.systemSymbol")
          .resizable()
          .foregroundColor(.red)
          .size(iconWidth)
          .x(-iconOffset)
          
        ,
        alignment: .trailing
      )
  }
  
  var trailingActions: some View {
    HStack {
      Spacer()
      Text("Trailing")
    }
    .displayIf(trailing.isNotEmpty)
  }
  
  func resetOffset() {
    // .timingCurve(0.5, 0.5, 0.8, 0.7
    withAnimation(.easeOut(duration: 0.45)) { offset = .zero }
  }
  
  var isOpened: Bool { offset >= totalLeadingWidth }
  
  @State private var shouldHapticFeedback: Bool = true
  @State private var shouldSendId: Bool = true
  
  func onChangedEvent(_ value: DragGesture.Value) {
    
    let width = value.translation.width
    if shouldSendId {
    SwipeManager.shared.swipingId = id
      shouldSendId = false
    }
    guard !isOpened else {
//      print("isOpened")
      if offset > totalLeadingWidth && shouldHapticFeedback {
      NotificationFeedback.shared.notificationOccurred(.success)
        shouldHapticFeedback = false
      }
      let maxAddOffset = width < .s2 ? width : .s2
      withAnimation { offset = totalLeadingWidth + maxAddOffset }
      
      
      return
    }
    
    withAnimation {
//      print("Modifiying offset...")
      offset = width
    }
  }
  
  func onEndedEvent(_ value: DragGesture.Value) {
    
    let width = value.translation.width
    
    shouldHapticFeedback = true
    shouldSendId = true
   
    
    guard leading.isNotEmpty else {
     return
    }
    
    
    if isOpened && (offset + width) > totalLeadingWidth {
      leading.first?.action()
    }
    
      if width > .s28 && width < totalLeadingWidth {
        withAnimation {
          offset = totalLeadingWidth
          SwipeManager.shared.rowIsOpened = true
        }
      } else if width > totalLeadingWidth {
        leading.first?.action()
        resetOffset()
        SwipeManager.shared.rowIsOpened = false
      } else {
        resetOffset()
        SwipeManager.shared.rowIsOpened = false
      }

  }
}
