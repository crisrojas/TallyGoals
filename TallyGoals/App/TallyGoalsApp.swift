//
//  TallyGoalsApp.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 27/05/2022.
//

import ComposableArchitecture
import SwiftUI

@main
struct TallyGoalsApp: App {
  
  let persistenceController = PersistenceController.shared
  
  init() {
    UIBarButtonItem.hideBackButtonLabel()
    UINavigationBar.setupFonts()
  }
  
  var body: some Scene {
    WindowGroup {
      Tabbar(store: container.store)
    }
  }
}
