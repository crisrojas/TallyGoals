//
//  Aliases.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import ComposableArchitecture

/// As described by pointfree.co:
/// _A store represents the runtime that powers the application. It is the object that you will pass around to views that need to interact with the application._
/// AppStore is a typealias to make code cleaner when passing store across views
typealias AppStore = Store<AppState, AppAction>

/// View store is an observable version of the store. Whenever the store changes,
/// views "listening" to the viewStore will be updated if needed
/// AppViewStore is a typealias to make code cleaner when passing viewStore across views
typealias AppViewStore = ViewStore<AppState, AppAction>

/// Whenever  an action is send to the store,
/// the app reducer handles it
typealias AppReducer = Reducer<AppState, AppAction, AppEnvironment>
