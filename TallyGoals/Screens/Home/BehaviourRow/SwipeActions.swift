//
//  SwipeActions.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 02/06/2022.
//
import SwiftUI
import SwiftUItilities

// @todo: take a look at this article for better notification handling
// https://www.hackingwithswift.com/books/ios-swiftui/adding-options-with-swipe-actions

final class SwipeManager: ObservableObject {
  
  @Published var swipingId: UUID?
  @Published var rowIsOpened: Bool = false
  
  var cancellables = Set<AnyCancellable>()
  
  static let shared = SwipeManager()
  private init() { }
  
  func collapse() {
    rowIsOpened = false
  }
}

struct SwipeAction: Identifiable, Equatable {

  static func == (lhs: SwipeAction, rhs: SwipeAction) -> Bool {
    lhs.id == rhs.id
  }

  let id: UUID = UUID()
  let label: String?
  let systemSymbol: String
  let action: () -> Void
  let backgroundColor: Color
  let tintColor: Color
  
  init(
    label: String?,
    systemSymbol: String,
    action: @escaping () -> Void,
    backgroundColor: Color = .black,
    tintColor: Color = .white
  ) {
    self.label = label
    self.systemSymbol = systemSymbol
    self.action = action
    self.backgroundColor = backgroundColor
    self.tintColor = tintColor
  }
  
}

struct SwipeActionView: View {
  
  @State var width: CGFloat
  let action: SwipeAction
  let callback: () -> Void
  private var iconOffset: CGFloat { (.actionWidth - width) / 2 }
 
  var body: some View {
    return action.backgroundColor
      .overlay(
        Image(systemName: action.systemSymbol)
          .foregroundColor(action.tintColor)
          .bindWidth(to: $width)
          .x(-iconOffset)
        ,
        alignment: .trailing
      )
      .onTap(perform: callback)
      .buttonStyle(.plain)
  }
}

extension CGFloat {
  static let actionWidth = CGFloat.s1 * 18
}

import Combine
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
      .actionWidth * leading.count
  }
  
  var leadingActions: some View {
   ZStack(alignment: .leading) {
      ForEach(leading.reversed().indices) { index in
        let action = leading.reversed()[index]
        let realIndex = leading.firstIndex(of: action)!
        let factor = (realIndex + 1).cgFloat
        let width = .actionWidth * factor
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
    let iconOffset = (.actionWidth - iconWidth) / 2
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

extension UIImpactFeedbackGenerator {
  
  static var shared: UIImpactFeedbackGenerator {
    UIImpactFeedbackGenerator(style: .medium)
  }
}

struct SparkSwipeActionModifier: ViewModifier {
  
  @State var width = CGFloat.zero
  @State var offset = CGFloat.zero
  @State var currentLeadingIndex = Int.zero
  @State var currentTrailingIndex = Int.zero
  
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

  
  var leadingGestures: some View {
    let initOffset = -.s6 + offset
    let treasholdReached = initOffset > .s3
    return ZStack {
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
  
  var trailingGestures: some View {
    let initOffset = .s6 + offset
    let treasholdReached = initOffset < -.s3
    return ZStack {
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
  
  @State var shouldHapticFeedback = true
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

extension View {

  func swipeActions(
    leading: [SwipeAction] = [],
    trailing: [SwipeAction] = []
  ) -> some View {
    
    self.modifier(
      SwipeActionModifier(
        leading: leading,
        trailing: trailing
      )
    )
  }
  
  func sparkSwipeActions(
    leading: [SwipeAction] = [],
    trailing: [SwipeAction] = []
  ) -> some View {
    self.modifier(SparkSwipeActionModifier(leading: leading, trailing: trailing))
  }
}

