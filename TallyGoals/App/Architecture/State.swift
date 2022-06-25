//
//  State.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//
import ComposableArchitecture
import CoreData
import SwiftUI

struct AppState: Equatable {
 
  var behaviourState: BehaviourState = .idle
  
  var overlay: Overlay?
}

enum Overlay: Equatable {
  case exploreDetail(PresetCategory)
}


