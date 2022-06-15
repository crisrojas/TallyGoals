//
//  Actions.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import ComposableArchitecture
import CoreData

enum AppAction {
  
  // MARK: - CRUD Behaviours
  case createBehaviour(
    emoji: String,
    name: String,
    completion: (() -> Void)?
  )
  
  case readBehaviours
  case loadBehaviours(result: Result<[Behaviour], Error>)
  
  case updateBehaviour(
    id: NSManagedObjectID,
    emoji: String,
    name: String,
    completion: (() -> Void)?
  )
  
  case archive(id: NSManagedObjectID)
  case unarchive(id: NSManagedObjectID)
  
  case updateFavorite(id: NSManagedObjectID, favorite: Bool)
  case updateArchive(id: NSManagedObjectID, archive: Bool)
  case updatePinned(id: NSManagedObjectID, pinned: Bool)
  
  case deleteBehaviour(id: NSManagedObjectID)
  
  // MARK: CRUD Entries
  case addEntry(behaviour: NSManagedObjectID)
  case deleteEntry(behaviour: NSManagedObjectID)
  
  case toggleAdding(value: Bool)
  
  case startEditingPinned
  case stopEditingPinned
  
  case toggleEditingMode(value: Bool)
  case startSwipe(id: NSManagedObjectID?)
  
  case updatePinnedPage(index: Int)
  
  case toggleTabbar
}
