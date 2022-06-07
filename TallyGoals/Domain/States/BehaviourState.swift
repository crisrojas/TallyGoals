enum BehaviourState: Equatable {
  case idle
  case loading
  case success([BehaviourEntity])
  case error(String)
  case empty
  
  static
  func make(from array: [BehaviourEntity]) -> BehaviourState {
    if array.isEmpty {
      return .empty
    } else {
      return .success(array)
    }
  }
}
