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


/// **Behaviour Repository:**
/// - Tests each action of the architecture related to the Behaviour Repository
/// - Indirectly test their implementations by the reducer.
/// - Indirectly test CoreData by using a inMemory viewContext
class BehaviourRepositoryTests: XCTestCase {
  
  var environment: AppEnvironment!
  
  override func setUpWithError() throws {
    
    /// Set environment on each test
    let inMemoryContext = PersistenceController(inMemory: true).container.viewContext
    let repository = BehaviourRepository(context: inMemoryContext)
    environment = AppEnvironment(behavioursRepository: repository)
  }
  
  override func tearDownWithError() throws {
    /// Reset environment on each test
    environment = nil
  }
  
  /// When fetching the database on first time, we should get an empty state (no behaviours)
  func testReadBehavioursOnFirstLaunch() {
    
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: environment
    )
    
    /// If we send the readBehaviours action,
    /// That should mutate behaviourState from 'idle' to loading
    store.send(.readBehaviours) {
      $0.behaviourState = .loading
    }
    
    /// Then, once the databaseFetched, we should:
    /// - Receive an makeBehaviourState action
    /// - Get an empty behaviourState
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
    
    wait(timeout: 0.05)
    
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
    
    
    switch action {
    case .favorite:
      behaviour.favorite = true
      expectedState = BehaviourState.success([behaviour])
      
      store.send(.updateFavorite(id: behaviour.id, favorite: true))
      wait()
      store.receive(.readBehaviours) {
        $0.behaviourState = .loading
      }
      store.receive(.makeBehaviourState(expectedState)) {
        $0.behaviourState = expectedState
      }
    case .archive:
      behaviour.archived = true
      expectedState = BehaviourState.success([behaviour])
      
      store.send(.updateArchive(id: behaviour.id, archive: true))
      wait()
      store.receive(.readBehaviours) {
        $0.behaviourState = .loading
      }
      store.receive(.makeBehaviourState(expectedState)) {
        $0.behaviourState = expectedState
      }
    case .pin:
      behaviour.pinned = true
      expectedState = BehaviourState.success([behaviour])
      
      store.send(.updatePinned(id: behaviour.id, pinned: true))
      wait()
      store.receive(.readBehaviours) {
        $0.behaviourState = .loading
      }
      store.receive(.makeBehaviourState(expectedState)) {
        $0.behaviourState = expectedState
      }
    }
  }
  
  /// If test fail with the following error:
  /// _"An effect returned for this action is still running. It must complete before the end of the test"_.
  /// That means, that specific test needs some more time in order to wait for the returned action to finish running,
  /// If that's the case you could override the default timeout (time to wait) argument by incrementing it a little
  private func wait(timeout: Double = 0.001) {
    _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: timeout)
  }
  
}
