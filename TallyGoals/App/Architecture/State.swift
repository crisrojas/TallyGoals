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
  
  var adding: Bool = true
  var isEditingPinned: Bool = false
  var isEditingMode: Bool = false
  var entries: [Entry] = []
  var goals: [Goal] = []
  var behaviourState: BehaviourState = .idle
  var swipingBehaviourId: NSManagedObjectID?
  var pinnedIndex = Int.zero
  
  var tabbarIsHidden = true
}
