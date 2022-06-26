//
//  OnboardingScreen.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 26/06/2022.
//
import ComposableArchitecture
import SwiftUI

struct OnboardingScreen: View {
  @AppStorage("showOnboarding") var showOnboarding: Bool = true
  @State var page: Int = .zero
  let store: AppStore
  private let betterWorldModel = presetsCategories.filter { $0.emoji == "🌻" }.first!
  
  var body: some View {
    
    WithViewStore(store) { viewStore in
      TabView(selection: $page) {
        
        VStack(spacing: 0) {
          
          Text("Bienvenu a TallyGoals")
            .roundedFont(.title)
            .fontWeight(.bold)
          
          Text("L'application qui vous aide à améliorer le monde a travers la réeducation du comportement")
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
          Text("1. Prenez conscience du comportement, des situations et des opportunités pour l'adopter")
            .top(.s4)
          Text("2. Obtenez la satisfaction d'incrementer le compteur")
            .top(.s1)
          
          Text("Compris")
            .top(.s6)
            .onTap {
              page += 1
            }
        }
        .tag(3)
        .horizontal(.horizontal)
        
        VStack {
          
          Text("Quelques examples")
            .roundedFont(.headline)
          
          ForEach(betterWorldModel.presets) { item in
            PresetRow(
              emoji: "🌻",
              model: item,
              viewStore: viewStore
            )
          }
          
          Text("Compris")
            .top(.s6)
            .onTap {
              showOnboarding = false
            }
        }
        .tag(4)
        .horizontal(.horizontal)
      }
      
      .roundedFont(.body)
      .multilineTextAlignment(.center)
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
  }
}


