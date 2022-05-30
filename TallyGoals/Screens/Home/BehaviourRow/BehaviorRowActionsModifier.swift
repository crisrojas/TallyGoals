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
 
  @State var trailingActionDynamicWidth = CGFloat.swipeActionWidth
  @State var leadingActionDynamicWidth = CGFloat.swipeActionWidth
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
    
    // wip:
    // Fixing gesture inconsistencies when scroll is triggered
    // https://stackoverflow.com/questions/57933593/how-to-only-disable-scroll-in-scrollview-but-not-content-view
      .simultaneousGesture(
        DragGesture()
          .onChanged { value in
            
            viewStore.send(.startSwipe(id: model.id))
            let width = value.translation.width
            
            if width > .swipeActionTotalWidth {
              let delta = width - .swipeActionTotalWidth
              leadingActionDynamicWidth = .swipeActionWidth + delta
            }
            
            if width < .swipeActionTotalWidth {
              let delta = abs(width) - .swipeActionTotalWidth
              trailingActionDynamicWidth = .swipeActionWidth + delta
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
              trailingActionDynamicWidth = .swipeActionWidth
              leadingActionDynamicWidth = .swipeActionWidth
              shouldVibrate = true
              willLaunchLeadingAction = false
              willLaunchTrailingAction = false
            }
            
            if width > 1 && width < .swipeActionsThreshold {
              withAnimation { offset = .swipeActionTotalWidth }
            } else if width < -1 && width > -.swipeActionsThreshold {
              withAnimation { offset = -.swipeActionTotalWidth }
            } else if width >= .swipeActionsThreshold {
              resetOffset()
              showEditingScreen = true
              isEditing = false
            } else if width <= -.swipeActionsThreshold {
              
              // @todo: ask before deleting
              resetOffset {
                viewStore.send(.deleteBehaviour(id: model.id))
              }
             
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
            position: .leading
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
          position: .trailing
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
  
  func resetOffset(completion: (() -> Void)? = nil) {
    withAnimation {
      offset = 0
    }
    completion?()
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
