enum BehaviourState: Equatable {
  case idle
  case loading
  case success([Behaviour])
  case error(String)
  case empty
  
  static
  func make(from array: [Behaviour]) -> BehaviourState {
    if array.isEmpty {
      return .empty
    } else {
      return .success(array)
    }
  }
}
