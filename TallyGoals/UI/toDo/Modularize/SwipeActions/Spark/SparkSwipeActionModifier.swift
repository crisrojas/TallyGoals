//
//  SparkSwipeActionModifier.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import SwiftUI

struct SparkSwipeActionModifier: ViewModifier {
  
  @State var width = CGFloat.zero
  @State var offset = CGFloat.zero
  @State var currentLeadingIndex = Int.zero
  @State var currentTrailingIndex = Int.zero
  @State var shouldHapticFeedback = true
  
  let leading: [SwipeAction]
  let trailing: [SwipeAction]
  
  func body(content: Content) -> some View {
    content
    .bindWidth(to: $width)
    .x(offset)
    .background(leadingGestures)
    .background(trailingGestures)
    .onChange(of: currentLeadingIndex, perform: handleIndexChange(_:))
    .onChange(of: currentTrailingIndex, perform: handleIndexChange(_:))
    .gesture(drag)
  }
  
  func handleIndexChange(_ index: Int) {
    guard index > 0 else { return }
    UIImpactFeedbackGenerator.shared.impactOccurred()
    
    #if DEBUG
    print("index changed: \(index)")
    #endif
  }
  
  @ViewBuilder
  var leadingGestures: some View {

    if leading.isEmpty {
      EmptyView()
    } else {
      
      let initOffset = -.s6 + offset
      let treasholdReached = initOffset > .s3
      
      ZStack {
        ForEach(0...leading.count - 1) { index in
          let isCurrent = index == currentLeadingIndex
          let item = leading[index]
          item.backgroundColor
            .opacity(treasholdReached ? 1 : 0)
            .opacity(isCurrent ? 1 : 0)
            .animation(.easeInOut(duration: 0.3), value: isCurrent)
        }
        .overlay(leadingGestureLabels, alignment: .leading)
      }
    }
  }
  
  @ViewBuilder
  var trailingGestures: some View {
   
    if trailing.isEmpty {
      EmptyView()
    } else {
      
      
      let initOffset = .s6 + offset
      let treasholdReached = initOffset < -.s3
      
      ZStack {
        ForEach(0...trailing.count - 1) { index in
          let isCurrent = index == currentTrailingIndex
          let item = trailing[index]
          item.backgroundColor
          .opacity(treasholdReached ? 1 : 0)
          .opacity(isCurrent ? 1 : 0)
          .animation(.easeInOut(duration: 0.3), value: isCurrent)
        }
        .overlay(trailingGestureLabels, alignment: .trailing)
      }
    }
  }
  
  @ViewBuilder
  var trailingGestureLabels: some View {
    let initOffset = .s6 + offset
    let treasholdReached = initOffset < -.s3
    let item = trailing.getOrNil(index: currentTrailingIndex)
    
    if let item = item {
      HStack {
        
        if let label =  item.label {
          Text(label)
            .opacity(treasholdReached ? 1 : 0)
        }
        
        Image(systemName: item.systemSymbol)
        
      }
      .foregroundColor(item.tintColor)
      .x(treasholdReached ? -.s3 : initOffset)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  var leadingGestureLabels: some View {
    let initOffset = -.s6 + offset
    let treasholdReached = initOffset > .s3
    let item = leading.getOrNil(index: currentLeadingIndex)
    
    if let item = item {
      HStack {
        
        Image(systemName: item.systemSymbol)
        if let label =  item.label {
          Text(label)
            .opacity(treasholdReached ? 1 : 0)
        }
      }
      .foregroundColor(item.tintColor)
      .x(treasholdReached ? .s3 : initOffset)
    } else {
      EmptyView()
    }
  }
  
  var drag: some Gesture {
    DragGesture()
    .onChanged(handleDragChange)
    .onEnded(handleDragEnd)
  }
  
  func handleDragChange(_ value: DragGesture.Value) {
    
    let horizontalTranslation = value.translation.width
    
    if horizontalTranslation > .s8 && shouldHapticFeedback {
      UIImpactFeedbackGenerator.shared.impactOccurred()
      shouldHapticFeedback = false
    }
    
    if horizontalTranslation < -.s8 && shouldHapticFeedback {
      UIImpactFeedbackGenerator.shared.impactOccurred()
      shouldHapticFeedback = false
    }
    
    withAnimation {
      offset = horizontalTranslation
    }
    
    let factor = horizontalTranslation / width
    
    currentLeadingIndex = Int(factor * leading.count)
    
    if horizontalTranslation < 0 {
      currentTrailingIndex = abs(Int(factor * trailing.count))
      print(currentTrailingIndex)
    }
  }
  
  func handleDragEnd(_ value: DragGesture.Value) {
    
    let horizontalTranslation = value.translation.width
    
    shouldHapticFeedback = true
    
    if horizontalTranslation >= .s12 {
      leading.getOrNil(index: currentLeadingIndex)?.action()
    }
    
    if horizontalTranslation <= -.s12 {
      trailing.getOrNil(index: currentTrailingIndex)?.action()
    }
    
    resetOffset()
  }
  
  func resetIndex() {
    withAnimation { currentLeadingIndex = 0 }
  }
  
  func resetOffset() {
    withAnimation { offset = 0 }
  }
}
