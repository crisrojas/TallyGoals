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
    Preset(name: "Oraciones profundas", isFeatured: true),
    Preset(name: "Repetir mantra: Te perdono"),
    Preset(name: "Ayudar a alguien", isFeatured: true),
    Preset(name: "Palabrotas")
  ]
  
 
  
  var cat2 = PresetCategory(emoji: "💪", name: "Voluntad y disciplina")
  cat2.presets = [
    Preset(name: "Tentaciones resistidas", isFeatured: true),
    Preset(name: "Recompensas retrasadas", isFeatured: true),
    Preset(name: "Levantarme sin postergar la alarma"),
    Preset(name: "Hacer algo que me de miedo", isFeatured: true),
    Preset(name: "Salir de mi zona de confort", isFeatured: true),
    Preset(name: "Ducha fría"),
    Preset(name: "Empezar por la tarea más dura")
  ]
  
  var cat3 = PresetCategory(emoji: "🌻", name: "Mundo mejor")
  cat3.presets = [
    Preset(name: "Llamar a seres queridos")
  ]
  
  
  var cat4 = PresetCategory(emoji: "💧", name: "Claridad mental")
 cat4.presets = [
  Preset(name: "Planificar el día siguiente"),
  Preset(name: "Organizar escritorio antes del final del día"),
  Preset(name: "Lavar los platos después de comer", isFeatured: true),
  Preset(name: "Organizar después de desordenar"),
  Preset(name: "Apagar el wifi"),
  Preset(name: "Actividad sin multitarea"),
  Preset(name: "Momento de reflexión e introspección al final del día"),
  Preset(name: "Desconectar al llegar del trabajo")
 ]
  
  var cat5 = PresetCategory(emoji: "💰", name: "Finanzas personales")
 cat5.presets = [
  Preset(name: "Leer un artículo sobre criptomonedas"),
  Preset(name: "Aguantar ganas de comprar algo sin pensar")
]
  
  var cat6 = PresetCategory(emoji: "🙂", name: "Bienetre")
 cat6.presets = [
  Preset(name: "Salir a pasear"),
  Preset(name: "Dopamine detox"),
  Preset(name: "Ayuno"),
  Preset(name: "Pensamiento negativo", isFeatured: true),
  Preset(name: "Aguanarse las ganas de hablar mal de alguien")
]
  
  
  var cat7 = PresetCategory(emoji: "⏰", name: "Gestion du temps")
 cat7.presets = [
  Preset(name: "Levantarme a las 7:00"),
  Preset(name: "Acostarme a las 22:30")
]
  
  var cat8 = PresetCategory(emoji: "🏋", name: "Sport")
 cat8.presets = [
  Preset(name: "Ir al trabajo en bicicleta"),
  Preset(name: "Ir al trabajo andando"),
  Preset(name: "Salir a correr")
 ]
  
 var cat9 = PresetCategory(emoji: "🥗", name: "Alimentation")
 cat9.presets = [
  Preset(name: "Comida cetogénica"),
  Preset(name: "Comida con una porción grande de ensalada"),
  Preset(name: "Día sin azúcares", isFeatured: true)
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
