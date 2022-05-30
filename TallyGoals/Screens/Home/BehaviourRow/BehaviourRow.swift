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

// @todo: take a look at this article for better notification handling
// https://www.hackingwithswift.com/books/ios-swiftui/adding-options-with-swipe-actions

struct SwipeAction: Identifiable {

  let id: UUID = UUID()
  let label: String?
  let systemSymbol: String
  let action: () -> Void
  let backgroundColor: Color
  let tintColor: Color
  
}

struct SwipeActionModifier: ViewModifier {
  
//  @Binding var offset: CGFloat
  @State var offset = CGFloat.zero
  let leading: [SwipeAction]
  let trailing: [SwipeAction]
  
  func body(content: Content) -> some View {
    content
//      .background(.black)
      .x(offset)
      .background(actions)
     
      .simultaneousGesture(
        DragGesture()
          .onChanged(onChangedEvent)
          .onEnded(onEndedEvent)
      )
//      .onTapGesture(perform: resetOffset)
  }
  
  var actions: some View {
    DefaultHStack {
      
      leadingActions
      trailingActions
    }
  }
  
  var leadingActions: some View {
    ForEach(leading.indices) { index in
        let action = leading[index]
        actionView(action, index: index)
      }
      .alignX(.leading)
      .displayIf(leading.isNotEmpty)
  }
  
  let actionWidth = CGFloat.s16
  
  func actionView(_ action: SwipeAction, index: Int) -> some View {
    let swipingTranslation = -actionWidth + offset
    let translation = swipingTranslation < 0 ? swipingTranslation : 0
    return action.backgroundColor
      .overlay(
        VStack {
          Image(systemName: action.systemSymbol)
          if let label = action.label {
            Text(label)
              .font(.caption2)
          }
        }
        .foregroundColor(action.tintColor)
      )
      .width(actionWidth)
      .x(translation)
  }
  
  var trailingActions: some View {
    HStack {
      Spacer()
      Text("Trailing")
    }
    .displayIf(trailing.isNotEmpty)
  }
  
  func resetOffset() {
    withAnimation { offset = .zero }
  }
  
  func onChangedEvent(_ value: DragGesture.Value) {
    
    let width = value.translation.width
    withAnimation { offset = width }
  }
  
  func onEndedEvent(_ value: DragGesture.Value) {
    
    let width = value.translation.width
    resetOffset()
  }
}

extension View {

  func swipeActions(
//    offset: Binding<CGFloat>,
    leading: [SwipeAction] = [],
    trailing: [SwipeAction] = []
  ) -> some View {
    
    self.modifier(
      SwipeActionModifier(
//        offset: offset,
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
//      .background(.black)
     
//      .background(dynamicBackground)
    
    // longpress inside a list https://stackoverflow.com/questions/69187017/how-to-implement-long-press-gesture-on-items-within-a-list-using-swiftui
//      .simultaneusLongGesture(perform: toggleDecreaseMode)
//      .highPriorityTapGesture(perform: highPriorityAction)
      .swipeActions(leading: leadingActions)
//      .swipeCell(
//        id: "\(model.id)",
////        cellWidth: T##CGFloat,
//        leadingSideGroup: leftGroup(),
//        trailingSideGroup: rightGroup(),
//        currentUserInteractionCellID: $currentUserInteractionCellID
////        settings: T##SwipeCellSettings
//      )
//      .navigationLink(editScreen, $showEditScreen)
//      .behaviourRowSwipeActions(
//        offset: $offset,
//        isEditing: $isDecreaseMode,
//        viewStore: viewStore,
//        background: dynamicBackground,
//        model: model
//      )
      /// @todo: use TCA state
      .onReceive(NotificationCenter.collapseRowNotification) { _ in
        stopDecreaseMode()
        resetOffsetIfNeeded()
      }
  }
  
  var leadingActions: [SwipeAction] {
    [
      SwipeAction(
        label: "Action 1",
        systemSymbol: "pencil",
        action: {},
        backgroundColor: .red,
        tintColor: .white),
      SwipeAction(
        label: "Action 2",
        systemSymbol: "minus",
        action: {},
        backgroundColor: .yellow,
        tintColor: .white),
    ]
  }
  
  func leftGroup()->[SwipeCellActionItem] {
          return [ SwipeCellActionItem(buttonView: {
              
              self.pinView(swipeOut: false)
              
          }, swipeOutButtonView: {
              self.pinView(swipeOut: true)
          }, buttonWidth: 80, backgroundColor: .yellow, swipeOutAction: true, swipeOutHapticFeedbackType: .success, swipeOutIsDestructive: false)
          {
              print("pin action!")
              self.isPinned.toggle()
          }]
      }

      
      func pinView(swipeOut: Bool)-> AnyView {

              Group {
                  Spacer()
                  VStack(spacing: 2) {
                      Image(systemName: self.isPinned ? "pin.slash": "pin").font(.system(size: 24)).foregroundColor(.white)
                      Text(self.isPinned ? "Unpin": "Pin").fixedSize().font(.system(size: 14)).foregroundColor(.white)
                  }.frame(maxHeight: 80).padding(.horizontal, swipeOut ? 20 : 5)
                  if swipeOut == false {
                      Spacer()
                  }
              }.animation(.default).castToAnyView()

      }

      func rightGroup()->[SwipeCellActionItem] {

          let items =  [
              SwipeCellActionItem(buttonView: {
      
                      VStack(spacing: 2)  {
                      Image(systemName: "person.crop.circle.badge.plus").font(.system(size: 22)).foregroundColor(.white)
                          Text("Share").fixedSize().font(.system(size: 12)).foregroundColor(.white)
                      }.frame(maxHeight: 80).castToAnyView()

              }, backgroundColor: .blue)
              {
                  print("share action!")
              },
              SwipeCellActionItem(buttonView: {
                      VStack(spacing: 2)  {
                      Image(systemName: "folder.fill").font(.system(size: 22)).foregroundColor(.white)
                          Text("Move").fixedSize().font(.system(size: 12)).foregroundColor(.white)
                      }.frame(maxHeight: 80).castToAnyView()
            
              }, backgroundColor: .purple, actionCallback: {
                  print("folder action")
              }),
              
              SwipeCellActionItem(buttonView: {
                  self.trashView(swipeOut: false)
              }, swipeOutButtonView: {
                  self.trashView(swipeOut: true)
              }, backgroundColor: .red, swipeOutAction: true, swipeOutHapticFeedbackType: .warning, swipeOutIsDestructive: true) {
                viewStore.send(.deleteBehaviour(id: model.id))
              }
            ]
          
          return items
      }
      
      func trashView(swipeOut: Bool)->AnyView {
              VStack(spacing: 3)  {
                  Image(systemName: "trash").font(.system(size: swipeOut ? 28 : 22)).foregroundColor(.white)
                  Text("Delete").fixedSize().font(.system(size: swipeOut ? 16 : 12)).foregroundColor(.white)
              }.frame(maxHeight: 80).animation(.default).castToAnyView()
          
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
