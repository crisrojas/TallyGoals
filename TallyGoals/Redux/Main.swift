import ComposableArchitecture
import CoreData
import SwiftUI

typealias AppStore = Store<AppState, AppAction>
typealias AppViewStore = ViewStore<AppState, AppAction>

struct AppState: Equatable {
  
  var adding: Bool = true
  var isEditingPinned: Bool = false
  var isEditingMode: Bool = false
  //var behaviours: [Behaviour] = []
  var entries: [Entry] = []
  var goals: [Goal] = []
  var behaviourState: BehaviourState = .idle
  var swipingBehaviourId: NSManagedObjectID?
}

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
}

struct AppEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let behavioursRepository: BehaviourRepository
}

extension AppEnvironment {
  static var instance: AppEnvironment {
    .init(
      mainQueue: .main,
      behavioursRepository: container.behaviourRepository
    )
  }
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, env in
  
  switch action {
    
  case .createBehaviour(let emoji, let name, let completion):
    completion?()
    return env.behavioursRepository
      .createBehaviour(emoji: emoji, name: name)
      .catchToEffect()
      .map { _ in AppAction.readBehaviours }
    
  case .readBehaviours:
    return env.behavioursRepository
      .readBehaviours()
      .catchToEffect()
      .map(AppAction.loadBehaviours)
    
  case .loadBehaviours(let result):
    switch result {
    case .success(let behaviours):
      withAnimation { state.behaviourState =  .success(behaviours) }
    case .failure(let error):
      state.behaviourState = .error(error.localizedDescription)
    }
    return .none
    
  case .updateFavorite(let id, let favorite):
    return env.behavioursRepository
      .updateFavorite(id: id, favorite: favorite)
      .catchToEffect()
      .map { _ in AppAction.readBehaviours }
    
  case .archive(let id):
    return env.behavioursRepository
      .updateArchived(id: id, archived: true)
      .catchToEffect()
      .map { _ in AppAction.readBehaviours }
    
  case .unarchive(let id):
    return env.behavioursRepository
      .updateArchived(id: id, archived: false)
      .catchToEffect()
      .map { _ in AppAction.readBehaviours }
    
  case .updateArchive(let id, let archived):
    return env.behavioursRepository
      .updateArchived(id: id, archived: archived)
      .catchToEffect()
      .map { _ in AppAction.readBehaviours }
    
  case .updatePinned(let id, let pinned):
    return env.behavioursRepository
      .updatePinned(id: id, pinned: pinned)
      .delay(for: .milliseconds(600), scheduler: env.mainQueue)
      .catchToEffect()
      .map { _ in AppAction.readBehaviours }
    
  case .updateBehaviour(let id, let emoji, let name, let completion):
    completion?()
    return env.behavioursRepository
      .updateBehaviour(id: id, emoji: emoji, name: name)
      .catchToEffect()
      .map { _ in AppAction.readBehaviours }
    
  case .deleteBehaviour(let id):
    return env.behavioursRepository
      .deleteBehaviour(id: id)
      .catchToEffect()
      .map { _ in AppAction.readBehaviours }
    
  case .deleteEntry(let id):
//    let lastIndex = state.entries.lastIndex(where: { $0.behaviourId == id })
//
//    if let lastIndex = lastIndex {
//      state.entries.remove(at: lastIndex)
//    }
//    return .none
    
    return env.behavioursRepository
    .deleteLastEntry(for: id)
    .catchToEffect()
    .map { _ in AppAction.readBehaviours }
    
  case .addEntry(let behaviourId):
    return env.behavioursRepository
    .createEntity(for: behaviourId)
    .catchToEffect()
    .map { _ in AppAction.readBehaviours }
    
  case .startEditingPinned:
    state.isEditingPinned = true
    return .none
    
  case .stopEditingPinned:
    state.isEditingPinned = false
    return .none
    
  case .toggleAdding(let value):
    state.adding = value
    return .none
    
  case .toggleEditingMode(let value):
    state.isEditingMode = value
    return .none
    
  case .startSwipe(let id):
    state.swipingBehaviourId = id
    return .none
  }
}
