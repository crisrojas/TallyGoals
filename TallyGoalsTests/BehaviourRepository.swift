//
//  TallyGoalsTests.swift
//  TallyGoalsTests
//
//  Created by Cristian Rojas on 27/05/2022.
//
//import ComposableArchitectureTestSupport
import ComposableArchitecture
import XCTest
@testable import TallyGoals


/*
 
 Tests for:
 
 - Behaviour Repository
 - Associated behaviour repository actions with reducer implementation
 */

class BehaviourRepositoryTests: XCTestCase {
  
  var environment: AppEnvironment!
  
  override func setUpWithError() throws {
    let inMemoryContext = PersistenceController(inMemory: true).container.viewContext
    let repository = BehaviourRepository(context: inMemoryContext)
    environment = AppEnvironment(behavioursRepository: repository)
  }
  
  override func tearDownWithError() throws {
    environment = nil
  }
  
  func testReadBehavioursOnFirstLaunch() {
    
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: environment
    )
    
    
    store.send(.readBehaviours) {
      $0.behaviourState = .loading
    }
    
    store.receive(.makeBehaviourState(.empty)) {
      $0.behaviourState = .empty
    }
  }
  
  func testCreateBehaviour() {
    
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: environment
    )
    
    let id = UUID()
    let emoji = "💧"
    let name = "Testing"
    
    let expectedBehaviours = [Behaviour(
      id: id,
      emoji: emoji,
      name: name,
      count: 0
    )]
    
    let expectedBehaviourState: BehaviourState = .success(expectedBehaviours)
    
    store.send(.createBehaviour(id: id, emoji: emoji, name: name))
    
    wait()
    
    store.receive(.readBehaviours) {
      $0.behaviourState = .loading
    }
    
    store.receive(.makeBehaviourState(expectedBehaviourState)) {
      $0.behaviourState = expectedBehaviourState
    }
  }
  
  private func wait() {
    _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
  }
  
  
  func testUpdateFavorite() {
    updateBehaviour(action: .favorite)
  }
  
  func testUpdatePinned() {
    updateBehaviour(action: .pin)
  }
  
  func testUpdateArchive() {
    updateBehaviour(action: .archive)
  }
  
  func testUpdateBehaviourMetaData() {
    var behaviour = Behaviour(
      id: UUID(),
      emoji: "🙂",
      name: "Be happy",
      count: 0
    )
    
    var expectedState = BehaviourState.success([behaviour])
    
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: environment
    )
    
    // MARK: - Create the behaviour
    store.send(.createBehaviour(
      id: behaviour.id,
      emoji: behaviour.emoji,
      name: behaviour.name
    ))
    
    wait()
    
    store.receive(.readBehaviours) {
      $0.behaviourState = .loading
    }
    store.receive(.makeBehaviourState(expectedState)) {
      $0.behaviourState = expectedState
    }
    
    
    /// Updated behaviour
    behaviour = Behaviour(
      id: behaviour.id,
      emoji: "🙂",
      name: "New name",
      count: behaviour.count
    )
    
    expectedState = .success([behaviour])
    
    
    store.send(.updateBehaviour(
      id: behaviour.id,
      emoji: behaviour.emoji,
      name: behaviour.name
    ))
    
    wait()
    
    store.receive(.readBehaviours) { $0.behaviourState = .loading }
    store.receive(.makeBehaviourState(expectedState)) {
      $0.behaviourState = expectedState
    }
  }
  
  func testDeleteBehaviour() {
    let behaviour = Behaviour(
      id: UUID(),
      emoji: "🙂",
      name: "Be happy",
      count: 0
    )
    
    let expectedFirstState = BehaviourState.success([behaviour])
    
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: environment
    )
    
    store.send(.createBehaviour(
      id: behaviour.id,
      emoji: behaviour.emoji,
      name: behaviour.name
    ))
    
    wait()
    
    store.receive(.readBehaviours) {
      $0.behaviourState = .loading
    }
    
    store.receive(.makeBehaviourState(expectedFirstState)) {
      $0.behaviourState = expectedFirstState
    }
    
    
    
    store.send(.deleteBehaviour(id: behaviour.id))
    
    wait()
    store.receive(.readBehaviours) {
      $0.behaviourState = .loading
    }
    store.receive(.makeBehaviourState(.empty)) {
      $0.behaviourState = .empty
    }
  }
  
  func testAddEntry() {
    var behaviour = Behaviour(
      id: UUID(),
      emoji: "🙂",
      name: "Be happy",
      count: 0
    )
    
    var expectedState = BehaviourState.success([behaviour])
    
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: environment
    )
    
    store.send(.createBehaviour(
      id: behaviour.id,
      emoji: behaviour.emoji,
      name: behaviour.name
    ))
    
    wait()
    store.receive(.readBehaviours) {
      $0.behaviourState = .loading
    }
    
    store.receive(.makeBehaviourState(expectedState)) {
      $0.behaviourState = expectedState
    }
    
    behaviour.count += 1
    expectedState = .success([behaviour])
    
    store.send(.addEntry(behaviour: behaviour.id))
    wait()
    store.receive(.readBehaviours) { $0.behaviourState = .loading}
    store.receive(.makeBehaviourState(expectedState)) {
      $0.behaviourState = expectedState
    }
  }
  
  func testDeleteEntry() {
    var behaviour = Behaviour(
      id: UUID(),
      emoji: "🙂",
      name: "Be happy",
      count: 0
    )
    
    var expectedState = BehaviourState.success([behaviour])
    
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: environment
    )
    
    store.send(.createBehaviour(
      id: behaviour.id,
      emoji: behaviour.emoji,
      name: behaviour.name
    ))
    wait()
    store.receive(.readBehaviours) {
      $0.behaviourState = .loading
    }
    store.receive(.makeBehaviourState(expectedState)) {
      $0.behaviourState = expectedState
    }
    
    behaviour.count += 1
    expectedState = .success([behaviour])
    
    store.send(.addEntry(behaviour: behaviour.id))
    wait()
    store.receive(.readBehaviours) { $0.behaviourState = .loading}
    store.receive(.makeBehaviourState(expectedState)) {
      $0.behaviourState = expectedState
    }
    
    behaviour.count -= 1
    expectedState = .success([behaviour])
    
    store.send(.deleteEntry(behaviour: behaviour.id))
    wait()
    store.receive(.readBehaviours) { $0.behaviourState = .loading }
    store.receive(.makeBehaviourState(expectedState)) {
      $0.behaviourState = expectedState
    }
  }
  
  private enum UpdateAction {
    case favorite
    case archive
    case pin
  }
  
  private func updateBehaviour(action: UpdateAction) {
    
    var behaviour = Behaviour(
      id: UUID(),
      emoji: "🙂",
      name: "Be happy",
      count: 0
    )
    
    let expectedFirstState = BehaviourState.success([behaviour])
    
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: environment
    )
    
    store.send(.createBehaviour(
      id: behaviour.id,
      emoji: behaviour.emoji,
      name: behaviour.name
    ))
    wait()
    store.receive(.readBehaviours) {
      $0.behaviourState = .loading
    }
    store.receive(.makeBehaviourState(expectedFirstState)) {
      $0.behaviourState = expectedFirstState
    }
    
    
    switch action {
    case .favorite:
      behaviour.favorite = true
      let expectedSecondState = BehaviourState.success([behaviour])
      
      store.send(.updateFavorite(id: behaviour.id, favorite: true))
      wait()
      store.receive(.readBehaviours) {
        $0.behaviourState = .loading
      }
      store.receive(.makeBehaviourState(expectedSecondState)) {
        $0.behaviourState = expectedSecondState
      }
    case .archive:
      behaviour.archived = true
      let expectedSecondState = BehaviourState.success([behaviour])
      
      store.send(.updateArchive(id: behaviour.id, archive: true))
      wait()
      store.receive(.readBehaviours) {
        $0.behaviourState = .loading
      }
      store.receive(.makeBehaviourState(expectedSecondState)) {
        $0.behaviourState = expectedSecondState
      }
    case .pin:
      behaviour.pinned = true
      let expectedSecondState = BehaviourState.success([behaviour])
      
      store.send(.updatePinned(id: behaviour.id, pinned: true))
      wait()
      store.receive(.readBehaviours) {
        $0.behaviourState = .loading
      }
      store.receive(.makeBehaviourState(expectedSecondState)) {
        $0.behaviourState = expectedSecondState
      }
    }
  }
}
