//
//  Overlay.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 26/06/2022.
//

import Foundation

/// Overlay model for presenting a view above the tabBar
enum Overlay: Equatable {
  case exploreDetail(PresetCategory)
  case error(title: String, message: String)
}
