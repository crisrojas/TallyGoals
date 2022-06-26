import ComposableArchitecture
import CoreData

/// Whenever  an action is send to the store,
/// the app reducer handles it
let appReducer = AppReducer { state, action, env in
  
  switch action {
   
  case .createBehaviour(let id, let emoji, let name):
    return env.behavioursRepository
      .createBehaviour(id: id, emoji: emoji, name: name)
      .catchToEffect()
      .map { _ in AppAction.readBehaviours }
    
  case .readBehaviours:
    state.behaviourState = .loading
    return env.behavioursRepository
    .fetchBehaviours()
    .catchToEffect()
    .map { result in
      var behaviourState: BehaviourState = .idle
      switch result {
      case .success(let behaviours):
        if behaviours.count > 0 {
        behaviourState = .success(behaviours)
        } else {
          behaviourState = .empty
        }
      case .failure(let error):
        behaviourState = .error(error.localizedDescription)
      }
      return .makeBehaviourState(behaviourState)
    }

  case .makeBehaviourState(let behaviourState):
    state.behaviourState = behaviourState
    return .none
    
  case .updateFavorite(let id, let favorite):
    return env.behavioursRepository
      .updateFavorite(id: id, favorite: favorite)
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
      .catchToEffect()
      .map { _ in AppAction.readBehaviours }
    
    
  case .updateBehaviour(let id, let emoji, let name):
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
    return env.behavioursRepository
    .deleteLastEntry(for: id)
    .catchToEffect()
    .map { _ in AppAction.readBehaviours }
  
    
  case .addEntry(let behaviourId):
    return env.behavioursRepository
    .createEntity(for: behaviourId)
    .catchToEffect()
    .map { _ in AppAction.readBehaviours }
  
    
  case .setOverlay(let overlay):
    state.overlay = overlay
    return .none
  }
}
