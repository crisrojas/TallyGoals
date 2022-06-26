//
//  TallyGoalsApp.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 27/05/2022.
//

import ComposableArchitecture
import SwiftUI


/// Entry point of the application
@main
struct TallyGoalsApp: App {
  
  @AppStorage("showOnboarding") var showOnboarding: Bool = true
  
  init() {
    UIBarButtonItem.hideBackButtonLabel()
    UINavigationBar.setupFonts()
  }
  
  var body: some Scene {
    WindowGroup {
      
      if showOnboarding {
        OnboardingScreen(store: container.store)
      } else {
        Tabbar(store: container.store)
      }
    }
  }
}
