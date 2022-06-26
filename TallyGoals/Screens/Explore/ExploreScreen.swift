//
//  ExploreScreen.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 13/06/2022.
//

import SwiftUI
import SwiftUItilities
import SwiftWind


var presetsCategories: [PresetCategory] {
  
  var cat1 = PresetCategory(emoji: "🙏", name: "Religion & Spiritualité")
  
  cat1.presets = [
    Preset(name: "Prières profondes", isFeatured: true),
    Preset(name: "Répetition de mantra: Je pardonne X"),
    Preset(name: "Aider quelqu'un", isFeatured: true),
    Preset(name: "Jeûne")
  ]
  
 
  
  var cat2 = PresetCategory(emoji: "💪", name: "Volonté et discipline")
  cat2.presets = [
    Preset(name: "Resister une tentation", isFeatured: true),
    Preset(name: "Recompense retardée", isFeatured: true),
    Preset(name: "Se lever dès que l'alarme sonne"),
    Preset(name: "Faire quelque chose d'intimidant", isFeatured: true),
    Preset(name: "Sortir de la zone de confort", isFeatured: true),
    Preset(name: "Douche froide"),
    Preset(name: "Commencer par la tâche plus difficile"),
    Preset(name: "Resister l'envie d'acheter quelque chose qu'on n'a pas planifié d'acheter"),
    Preset(name: "Resister l'envie de manger quelque chose qu'on n'a pas planifié de manger")
  ]
  
  var cat3 = PresetCategory(emoji: "🌻", name: "Améliorer le monde")
  cat3.presets = [
    Preset(name: "Appeler ses proches"),
    Preset(name: "Aider quelqu'un", isFeatured: true),
    Preset(name: "Faire une action sociale", isFeatured: true)
  ]
  
  
  var cat4 = PresetCategory(emoji: "💧", name: "Claridad mental")
 cat4.presets = [
  Preset(name: "Planifier le lendemain"),
  Preset(name: "Ranger bureau à la fin de la journée"),
  Preset(name: "Faire la vaiselle juste après manger", isFeatured: true),
  Preset(name: "Éteindre le wifi"),
  Preset(name: "Activité sans multitâche"),
  Preset(name: "Introspecter à la fin de la journée"),
  Preset(name: "Se déconnecter des résaux sociaux au retour du travail")
 ]
  
  var cat5 = PresetCategory(emoji: "💰", name: "Finanzas personales")
 cat5.presets = [
  Preset(name: "Lire un article sur les criptomonnais"),
  Preset(name: "Resister l'envie d'acheter quelque chose qu'on n'a pas planifié d'acheter")
]
  
  var cat6 = PresetCategory(emoji: "🙂", name: "Bienetre")
 cat6.presets = [
  Preset(name: "Faire une promenade"),
  Preset(name: "Dopamine detox"),
  Preset(name: "Jeûne"),
  Preset(name: "Pensée négative automatique", isFeatured: true),
  Preset(name: "Resister envie de mal parler de quelqu'un avec qui on a eu un conflit")
]
  
  
  var cat7 = PresetCategory(emoji: "⏰", name: "Gestion du temps")
 cat7.presets = [
  Preset(name: "Se lever à 7:00"),
  Preset(name: "Se coucher à las 22:30")
]
  
  var cat8 = PresetCategory(emoji: "🏋", name: "Sport")
 cat8.presets = [
  Preset(name: "Aller en vélo aux travail"),
  Preset(name: "Aller à pied au travail"),
  Preset(name: "Faire du running")
 ]
  
 var cat9 = PresetCategory(emoji: "🥗", name: "Alimentation")
 cat9.presets = [
  Preset(name: "Repas ketogénique"),
  Preset(name: "Repas avec une grande part de salada"),
  Preset(name: "Journée sans sucre", isFeatured: true)
]
  
  return [cat1, cat2, cat3, cat4, cat5, cat6, cat7, cat8, cat9]
}

struct ExploreScreen: View {
  @State var showDetail = false
  @GestureState var isPressed = false
  
  @Namespace var namespace
  let viewStore: AppViewStore
  
  
  private let columns = [
    GridItem(.flexible(), spacing: .s4),
    GridItem(.flexible(), spacing: .s4)
  ]
  
  let feauredModel = presetsCategories.map { presetCategory in
    return (presetCategory, presetCategory.presets.filter { $0.isFeatured })
  }
  
  var body: some View {
      DefaultVStack {
        
        LazyVGrid(columns: columns, spacing: .s4) {
          
          ForEach(presetsCategories) { category in
            ExplorePresetCard(model: category, viewStore: viewStore)
          }
        }
      }
      .horizontal(.s4)
      .vertical(.s6)
      .scrollify()
  }
}
