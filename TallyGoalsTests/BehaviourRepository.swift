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
 - Associated behaviour repository actions
 - Associated behaviour repository reducer action implementation
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
    let name = "Testing 2"
    
    let expectedBehaviours = [Behaviour(
      id: id,
      emoji: emoji,
      name: name,
      count: 0
    )]
    
    let expectedBehaviourState: BehaviourState = .success(expectedBehaviours)
    
    store.assert(
      .send(.createBehaviour(
        id: id,
        emoji: emoji,
        name: name
      )) {
        $0.behaviourState = .idle
      },
      .do {
        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
      },
      .receive(.readBehaviours) {
        $0.behaviourState = .loading
      },
      .receive(.makeBehaviourState(expectedBehaviourState)) {
        $0.behaviourState = expectedBehaviourState
      }
    )
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
    let behaviour = Behaviour(
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
    store.assert(
      .send(.createBehaviour(
        id: behaviour.id,
        emoji: behaviour.emoji,
        name: behaviour.name
      )) {
        $0.behaviourState = .idle
      },
      .do {
        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
      },
      .receive(.readBehaviours) {
        $0.behaviourState = .loading
      },
      .receive(.makeBehaviourState(expectedState)) {
        $0.behaviourState = expectedState
      }
    )
    
    // MARK: - Update name
    let updatedBehaviour = Behaviour(
      id: behaviour.id,
      emoji: "🙂",
      name: "New name",
      count: behaviour.count
    )
    
    expectedState = .success([updatedBehaviour])
    
    store.assert(
      .send(.updateBehaviour(
        id: behaviour.id,
        emoji: updatedBehaviour.emoji,
        name: updatedBehaviour.name
      )),
      .do {
        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
      },
      .receive(.readBehaviours) { $0.behaviourState = .loading },
      .receive(.makeBehaviourState(expectedState)) {
        $0.behaviourState = expectedState
      }
    )
    
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
    
    store.assert(
      .send(.createBehaviour(
        id: behaviour.id,
        emoji: behaviour.emoji,
        name: behaviour.name
      )) {
        $0.behaviourState = .idle
      },
      .do {
        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
      },
      .receive(.readBehaviours) {
        $0.behaviourState = .loading
      },
      .receive(.makeBehaviourState(expectedFirstState)) {
        $0.behaviourState = expectedFirstState
      }
    )
    
    
    store.assert(
      .send(.deleteBehaviour(id: behaviour.id)),
      .do {
        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
      },
      .receive(.readBehaviours) {
        $0.behaviourState = .loading
      },
      .receive(.makeBehaviourState(.empty)) {
        $0.behaviourState = .empty
      }
    )
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
    
    store.assert(
      .send(.createBehaviour(
        id: behaviour.id,
        emoji: behaviour.emoji,
        name: behaviour.name
      )) {
        $0.behaviourState = .idle
      },
      .do {
        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
      },
      .receive(.readBehaviours) {
        $0.behaviourState = .loading
      },
      .receive(.makeBehaviourState(expectedState)) {
        $0.behaviourState = expectedState
      }
    )
    
    behaviour.count += 1
    expectedState = .success([behaviour])
    
    store.assert(
      .send(.addEntry(behaviour: behaviour.id)),
      .do {
        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
      },
      .receive(.readBehaviours) { $0.behaviourState = .loading},
      .receive(.makeBehaviourState(expectedState)) {
        $0.behaviourState = expectedState
      }
    )
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
    
    store.assert(
      .send(.createBehaviour(
        id: behaviour.id,
        emoji: behaviour.emoji,
        name: behaviour.name
      )) {
        $0.behaviourState = .idle
      },
      .do {
        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
      },
      .receive(.readBehaviours) {
        $0.behaviourState = .loading
      },
      .receive(.makeBehaviourState(expectedState)) {
        $0.behaviourState = expectedState
      }
    )
    
    behaviour.count += 1
    expectedState = .success([behaviour])
    
    store.assert(
      .send(.addEntry(behaviour: behaviour.id)),
      .do {
        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
      },
      .receive(.readBehaviours) { $0.behaviourState = .loading},
      .receive(.makeBehaviourState(expectedState)) {
        $0.behaviourState = expectedState
      }
    )
    
    behaviour.count -= 1
    expectedState = .success([behaviour])
    
    store.assert(
      .send(.deleteEntry(behaviour: behaviour.id)),
      .do {
        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
      },
      .receive(.readBehaviours) { $0.behaviourState = .loading },
      .receive(.makeBehaviourState(expectedState)) {
        $0.behaviourState = expectedState
      }
    )
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
    
    store.assert(
      .send(.createBehaviour(
        id: behaviour.id,
        emoji: behaviour.emoji,
        name: behaviour.name
      )) {
        $0.behaviourState = .idle
      },
      .do {
        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
      },
      .receive(.readBehaviours) {
        $0.behaviourState = .loading
      },
      .receive(.makeBehaviourState(expectedFirstState)) {
        $0.behaviourState = expectedFirstState
      }
    )
    
    
    switch action {
    case .favorite:
      behaviour.favorite = true
      let expectedSecondState = BehaviourState.success([behaviour])
      
      store.assert(
        .send(.updateFavorite(id: behaviour.id, favorite: true)),
        .do {
          _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
        },
        .receive(.readBehaviours) {
          $0.behaviourState = .loading
        },
        .receive(.makeBehaviourState(expectedSecondState)) {
          $0.behaviourState = expectedSecondState
        }
      )
    case .archive:
      behaviour.archived = true
      let expectedSecondState = BehaviourState.success([behaviour])
      
      store.assert(
        .send(.updateArchive(id: behaviour.id, archive: true)),
        .do {
          _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
        },
        .receive(.readBehaviours) {
          $0.behaviourState = .loading
        },
        .receive(.makeBehaviourState(expectedSecondState)) {
          $0.behaviourState = expectedSecondState
        }
      )
    case .pin:
      behaviour.pinned = true
      let expectedSecondState = BehaviourState.success([behaviour])
      
      store.assert(
        .send(.updatePinned(id: behaviour.id, pinned: true)),
        .do {
          _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
        },
        .receive(.readBehaviours) {
          $0.behaviourState = .loading
        },
        .receive(.makeBehaviourState(expectedSecondState)) {
          $0.behaviourState = expectedSecondState
        }
      )
    }
  }
}
