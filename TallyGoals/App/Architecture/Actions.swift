//
//  Actions.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import ComposableArchitecture
import CoreData

/// The AppAction enum models the actions of the app
/// This actions are send to the store by using the send method which take an action as argument
/// Actions are handle by the reducer
enum AppAction: Equatable {

  // MARK: - CRUD Behaviours
  case createBehaviour(
    id: UUID,
    emoji: String,
    name: String
  )
  
  case readBehaviours
  case makeBehaviourState(_ state: BehaviourState)
  
  case updateBehaviour(
    id: UUID,
    emoji: String,
    name: String
  )
  
  case updateFavorite(id: UUID, favorite: Bool)
  case updateArchive(id: UUID, archive: Bool)
  case updatePinned(id: UUID, pinned: Bool)
  
  case deleteBehaviour(id: UUID)
  
  // MARK: CRUD Entries
  case addEntry(behaviour: UUID)
  case deleteEntry(behaviour: UUID)
  
  case setOverlay(overlay: Overlay?)
}
