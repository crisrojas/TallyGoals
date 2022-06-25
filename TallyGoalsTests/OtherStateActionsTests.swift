//
//  OtherStateActionsTests.swift
//  TallyGoalsTests
//
//  Created by Cristian Rojas on 25/06/2022.
//
import ComposableArchitecture
import XCTest
@testable import TallyGoals

/*
 
 Tests the overlay manager on state
 */

class OtherStateActionsTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

  func testSetOverlay() {
    
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(behavioursRepository: BehaviourRepository(context: PersistenceController.preview.container.viewContext))
    )
    
    let presetCategory = PresetCategory(
      emoji: "💧",
      name: "Mental clarity"
    )
    
    let overlayModel = Overlay.exploreDetail(presetCategory)
    
    store.send(.setOverlay(overlay: overlayModel)) {
      $0.overlay = overlayModel
    }
  }

}
