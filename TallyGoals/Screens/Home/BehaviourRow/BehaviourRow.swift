//
//  BehaviourRow.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 27/05/2022.
//

import SwiftUI
import SwiftUItilities
import SwiftWind
import SwipeCellSUI
import ComposableArchitecture
import StoreKit

extension Array {
  var count: CGFloat {
    self.count.cgFloat
  }
}

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
        
        SwipeActionView(width: maxWidth, action: action, callback: callback)
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
        Image(systemName: action.systemSymbol)
          .resizable()
        // @todo: Use width binding to make the calculation, this breaks icons like "minus"
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

extension View {

  func swipeActions(
//    offset: Binding<CGFloat>,
//    id: Binding<UUID>,
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
}

struct BehaviourRow: View {
  
  @State var offset: CGFloat = .zero
  
  @State var showEditScreen = false
  @State var isDecreaseMode = false
  @State var isCountShaking: Bool = false
  
  /// @todo: this should take only the model.id?
  let model: Behaviour
  let viewStore: AppViewStore
  
      @State private var isPinned: Bool = false
      @Binding var currentUserInteractionCellID: String?
  
  var body: some View {
    
    row()
      .background(dynamicBackground)
      .simultaneusLongGesture(perform: toggleDecreaseMode)
      .highPriorityTapGesture(perform: highPriorityAction)

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
      
      Text(model.count.string)
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
    withAnimation {
      viewStore.send(.addEntry(behaviour: model.id))
    }
  }
  
  func decrease() {
    guard model.count > 0 else {
      vibrate(.error)
      withAnimation { shakeCount() }
      return
    }
    
    vibrate()
    withAnimation {
      viewStore.send(.deleteEntry(behaviour: model.id))
    }
  }
  
  func shakeCount() {
    isCountShaking.toggle()
  }
 
  func highPriorityAction() {
   
    currentUserInteractionCellID = nil
    guard viewStore.swipingBehaviourId == nil else {
      viewStore.send(.startSwipe(id: nil))
      return
    }
    
    guard offset == 0 else {
      resetOffsetIfNeeded()
      return
    }
    
    guard !SwipeManager.shared.rowIsOpened else {
      SwipeManager.shared.collapse()
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
