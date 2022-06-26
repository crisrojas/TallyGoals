//
//  WindColors.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import SwiftUI
import SwiftWind

/// Enum allows iteration for demo purposes (showing all colors)
/// This will replace the WindColor struct on SwiftWind on a future release
enum WindColors: Int, CaseIterable {
  case slate
  case gray
  case zinc
  case neutral
  case stone
  case red
  case orange
  case yellow
  case lime
  case green
  case emerald
  case teal
  case cyan
  case sky
  case blue
  case indigo
  case violet
  case amber
  case purple
  case fuchsia
  case pink
  case rose

  
  var color: WindColor {
    switch self {
      
    case .amber:
      return .amber
    case .purple:
      return .purple
    case .slate:
      return .slate
    case .gray:
      return .gray
    case .zinc:
      return .zinc
    case .neutral:
      return .neutral
    case .stone:
      return .stone
    case .red:
      return .red
    case .orange:
      return .orange
    case .yellow:
      return .yellow
    case .lime:
      return .lime
    case .green:
      return .green
    case .emerald:
      return .emerald
    case .teal:
      return .teal
    case .cyan:
      return .cyan
    case .sky:
      return .sky
    case .blue:
      return .blue
    case .indigo:
      return .indigo
    case .violet:
      return .violet
    case .fuchsia:
      return .fuchsia
    case .pink:
      return .pink
    case .rose:
      return .rose
    }
  }
  
  var t50: Color {
    switch self {
    case .slate:
      return .slate50
    case .gray:
      return .gray50
    case .zinc:
      return .zinc50
    case .neutral:
      return .neutral50
    case .stone:
      return .stone50
    case .red:
      return .red50
    case .orange:
      return .orange50
    case .yellow:
      return .yellow50
    case .lime:
      return .lime50
    case .green:
      return .green50
    case .emerald:
      return .emerald50
    case .teal:
      return .teal50
    case .cyan:
      return .cyan50
    case .sky:
      return .sky50
    case .blue:
      return .blue50
    case .indigo:
      return .indigo50
    case .violet:
      return .violet50
    case .amber:
      return .amber50
    case .purple:
      return .purple50
    case .fuchsia:
      return .fuchsia50
    case .pink:
      return .pink50
    case .rose:
      return .rose50
    }
  }
}
