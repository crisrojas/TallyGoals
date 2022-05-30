//
//  SwipeActionsView.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 29/05/2022.
//

import SwiftUI
import SwiftWind

struct SwipeActionView: View {
  
  @Binding var offset: CGFloat
  
  let color: WindColor
  let systemSymbol: String
  
  let position: ActionPosition
  let width: CGFloat
  let launching: Bool
  let action: () -> ()
  
  init(
    offset: Binding<CGFloat>,
    color: WindColor,
    systemSymbol: String,
    position: ActionPosition,
    width: CGFloat = .swipeActionWidth,
    launching: Bool = false,
    action: @escaping () -> ()
  ) {
    self._offset = offset
    self.color = color
    self.systemSymbol = systemSymbol
    self.position = position
    self.width = width
    self.launching = launching
    self.action = action
  }
  
  var body: some View {
    backgroundColor
    // wip: fixing runtime frame error
      .width(width > 0 ? width : .s10)
      .buttonStyle(.plain)
      .onTap {
        withAnimation {
          offset = .zero
          action()
        }
      }
      .overlay(
        Image(systemName: systemSymbol)
          .foregroundColor(tintColor)
          .x(launching ? position.launchingOffset : 0)
        ,
        alignment: launching ? position.launchingAlingment : .center
      )
  }
  
  var backgroundColor: Color {
    if .isDarkMode {
      return color.c100
    } else {
      return color.c600
    }
  }
  
  var tintColor: Color {
    if .isDarkMode {
      return color.c600
    } else {
      return color.c100
    }
  }
}

// MARK:- SubModels
extension SwipeActionView {
  
  enum ActionPosition {
    case trailing
    case leading
    
    
    var launchingOffset: CGFloat {
      
      switch self {
      case .trailing: return .swipeActionLaunchingOffset
      case .leading: return -.swipeActionLaunchingOffset
      }
    }
    
    var launchingAlingment: Alignment {
      switch self {
      case .trailing: return .leading
      case .leading: return .trailing
      }
    }
  }
}
