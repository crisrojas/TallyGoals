//
//  TallyGoalsApp.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 27/05/2022.
//

import ComposableArchitecture
import SwiftUI


/*
 
 @todo: Translate presets to french
 @todo: Add unit tests
 @todo: Clean project a bit from legacy code (like listrow)
 @todo: Test on iphone SE
 @todo: Test light mode
 */

@main
struct TallyGoalsApp: App {
  
  @AppStorage("showOnboarding") var showOnboarding: Bool = true
  let persistenceController = PersistenceController.shared
  
  init() {
    UIBarButtonItem.hideBackButtonLabel()
    UINavigationBar.setupFonts()
  }
  
  var body: some Scene {
    WindowGroup {
      
      if showOnboarding {
        OnboardingScreen()
      } else {
        Tabbar(store: container.store) .onAppear {
//          showOnboarding = true
        }
      }
    }
    
  }
}

struct FeaturedItem: Identifiable {
  let id = UUID()
  let emoji: String
  let name: String
}
struct OnboardingScreen: View {
  @AppStorage("showOnboarding") var showOnboarding: Bool = true
  @State var page: Int = .zero
  
  let featuredModel = presetsCategories.map { category in
    category.presets.map {
      FeaturedItem(emoji: category.emoji, name: $0.name )
    }
  }
  .flatMap { $0 }
  
  var body: some View {
    
    TabView(selection: $page) {
      
      VStack(spacing: 0) {
        
        Text("Bienvenu a TallyGoals")
          .roundedFont(.title)
          .fontWeight(.bold)
        
        Text("L'application qui vous aide a améliorer le monde a travers la réeducation du comportement")
          .top(.s2)
        
        Text("Suivant")
          .top(.s6)
          .onTap {
            page += 1
          }
        
      }
      .tag(0)
      .horizontal(.horizontal)
      
      VStack {
        Text("Pour utiliser l'application, vous chossirez le(s) comportement(s) que vous souhaitez adopter")
        
        Text("Par example:")
        .fontWeight(.bold)
        .top(.s2)
             
         Text("🙏 Aider quelqu'un")
        
        
        Text("Compris")
          .onTap { page += 1 }
          .top(.s6)
      }
      .tag(1)
      .horizontal(.horizontal)
      
      VStack {
        Text("Chaque fois que vous adoptez ce comportement:")
        .roundedFont(.headline)
        .fontWeight(.bold)
        
        
        Text("1. Ouvrez l'application")
          .top(.s2)
        Text("2. Incrementez le compteur associé")
        
        Text("Suivant")
        .top(.s6)
          .onTap {
            page += 1
          }
      }
      .tag(2)
      .horizontal(.horizontal)
      
      
      VStack {
        
        Text("En ce faisant, vous:")
        .roundedFont(.headline)
        Text("1. Prennez conscience du comportement et des situations et opportunités pour le manifester")
        .top(.s4)
        Text("2. Obtenez la recompense de voir le compteur s'incrementer et avec une source de motivation pour continuer a l'adopter")
        .top(.s1)
        
        Text("Compris")
        .top(.s6)
          .onTap {
            showOnboarding = false
          }
      }
      .tag(3)
      .horizontal(.horizontal)
      
//      VStack {
//        Text("Avant de lancer l'app on souhaiterais vous proposer une série de compteurs préselectionnés pour rendre le monde un endroit mieux")
//        Text("Oui, c'est parti!")
//          .onTap {
//            showOnboarding = false
//          }
//        Text("Non merci")
//          .onTap {
//            showOnboarding = false
//          }
//
//      }
//      .tag(4)
//      .horizontal(.horizontal)
    }
    
          .roundedFont(.body)
    .multilineTextAlignment(.center)
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    //      .onTap { showOnboarding = false }
  }
}
