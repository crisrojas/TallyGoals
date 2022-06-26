//
//  State.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//
import ComposableArchitecture
import CoreData
import SwiftUI


/// The AppState is responsible to holds the states of the app
/// that are needed in all views.
/// This allows a view to be automatically be reloaded as a side-effect of an action in other view
/// which allows for cleaner code (don't need to reload through callbacks/notifications/delegates...)
struct AppState: Equatable {
 
  var behaviourState: BehaviourState = .idle
  var overlay: Overlay?
}

