//
//  BehaviorRowActionsModifier.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 29/05/2022.
//

import SwiftUI
import SwiftUItilities

struct BehaviorRowActionsModifier: ViewModifier {
  
  @Binding var offset: CGFloat
  @Binding var isEditing: Bool

  let background: Color
  let model: Behaviour
  let viewStore: AppViewStore
 
  @State var trailingActionDynamicWidth = CGFloat.s10
  @State var leadingActionDynamicWidth = CGFloat.s10
  @State var shouldVibrate: Bool = true
  @State var willLaunchLeadingAction = false
  @State var willLaunchTrailingAction = false
  @State var showEditingScreen = false
  
  func body(content: Content) -> some View {
    content
      .offset(x: offset)
      .navigationLink(editingScreen, $showEditingScreen)
      .background(swipeActions)
      .onChange(of: viewStore.state.swipingBehaviourId) { swipedId in
        if swipedId != model.id {
          resetOffset()
        }
      }
      .gesture(
        DragGesture()
          .onChanged { value in
            
            
            viewStore.send(.startSwipe(id: model.id))
            let width = value.translation.width
            
            if width > .s20 {
              let delta = width - .s20
              leadingActionDynamicWidth = .s10 + delta
            }
            
            if width < .s20 {
              let delta = abs(width) - .s20
              trailingActionDynamicWidth = .s10 + delta
            }
            
            if width > .s36 && shouldVibrate {
              vibrate()
              withAnimation { willLaunchLeadingAction = true }
              shouldVibrate = false
            }
            
            if width < -.s36 && shouldVibrate {
              vibrate()
              withAnimation { willLaunchTrailingAction = true }
              shouldVibrate = false
            }
            
            offset = width
          }
          .onEnded { value in
            let width = value.translation.width
            
            /// Reset state values
            withAnimation {
              trailingActionDynamicWidth = .s10
              leadingActionDynamicWidth = .s10
              shouldVibrate = true
              willLaunchLeadingAction = false
              willLaunchTrailingAction = false
            }
            
            if width > 1 && width < .s40 {
              withAnimation { offset = .s20 }
            } else if width < -1 && width > -.s40 {
              withAnimation { offset = -.s20 }
            } else if width >= .s40 {
              resetOffset()
              showEditingScreen = true
              isEditing = false
            } else if width <= -.s40 {
              
              // @todo: ask before deleting
              viewStore.send(.deleteBehaviour(id: model.id))
            } else {
              resetOffset()
            }
          }
      )
  }
  
 
  var swipeActions: some View {
    
    background.overlay(
      DefaultHStack {
        
        // MARK: - Leading
        Group {
          SwipeActionView(
            offset: $offset,
            color: .green,
            systemSymbol: "pencil",
            position: .leading,
            width: leadingActionDynamicWidth,
            launching: willLaunchLeadingAction
          ) {
            isEditing = false
            showEditingScreen = true
          }
          
          SwipeActionView(
            offset: $offset,
            color: .yellow,
            systemSymbol: "pin",
            position: .leading,
            width: .s10
          ) {
            viewStore.send(
              .updatePinned(id: model.id, pinned: true)
            )
          }
        }
        
        
        Spacer()
        
        // MARK: - Trailing
        SwipeActionView(
          offset: $offset,
          color: .orange,
          systemSymbol: "archivebox",
          position: .trailing,
          width: .s10
        ) {
          viewStore.send(.updateArchive(id: model.id, archive: true))
        }
        
        SwipeActionView(
          offset: $offset,
          color: .red,
          systemSymbol: "trash",
          position: .trailing,
          width: trailingActionDynamicWidth,
          launching: willLaunchTrailingAction
        ) {
          viewStore.send(.deleteBehaviour(id: model.id))
        }
      }
    )
  }
  
  func resetOffset() {
    withAnimation { offset = 0 }
  }
  
  var editingScreen: some View {
    BehaviourEditScreen(
      viewStore: viewStore,
      item: model,
      emoji: model.emoji,
      name: model.name
    )
  }
}
