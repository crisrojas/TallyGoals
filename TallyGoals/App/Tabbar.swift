import ComposableArchitecture
import Introspect
import SwiftUI
import SwiftUItilities
import SwiftWind
import AVFoundation

struct Sequence {
  let behaviours: [BehaviourItem]
}

struct BehaviourItem {
  let behaviour: Behaviour
  let time: Double
}

struct Preset: Identifiable {
  
  var id: String {
    "\(emoji)+\(name)"
  }
  
  let emoji: String
  let name: String
  let description: String?
  let isFeatured: Bool
  
  init(
    emoji: String,
    name: String,
    description: String? = nil,
    isFeatured: Bool = false
  ) {
    self.emoji = emoji
    self.name = name
    self.description = description
    self.isFeatured = isFeatured
  }
}

var presets: [Preset] = [
  Preset(emoji: "🙏", name: "Oraciones profundas", isFeatured: true),
  Preset(emoji: "💪", name: "Tentaciones resistidas", isFeatured: true),
  Preset(emoji: "💪", name: "Recompensas retrasadas", isFeatured: true),
  Preset(emoji: "💪", name: "Levantarme sin postergar la alarma"),
  Preset(emoji: "💧", name: "Planificar el día siguiente"),
  Preset(emoji: "💧", name: "Organizar escritorio antes del final del día"),
  Preset(emoji: "💧", name: "Lavar los platos después de comer", isFeatured: true),
  Preset(emoji: "💧", name: "Organizar después de desordenar"),
  Preset(emoji: "💧", name: "Apagar el wifi"),
  Preset(emoji: "💧", name: "Actividad sin multitarea"),
  Preset(emoji: "🤩", name: "Lavar cara"),
  Preset(emoji: "🙏", name: "Repetir mantra: Te perdono"),
  Preset(emoji: "💧", name: "Desconectar al llegar del trabajo"),
  Preset(emoji: "🫂", name: "Llamar a seres queridos"),
  Preset(emoji: "🙏", name: "Ayudar a alguien", isFeatured: true),
  Preset(emoji: "🙂", name: "Salir a pasear"),
  Preset(emoji: "🙂", name: "Dopamine detox"),
  Preset(emoji: "🙂", name: "Ayuno"),
  Preset(emoji: "💰", name: "Leer un artículo sobre criptomonedas"),
  Preset(emoji: "💰", name: "Aguantar ganas de comprar algo sin pensar"),
  Preset(emoji: "⏰", name: "Levantarme a las 7:00"),
  Preset(emoji: "💪", name: "Ducha fría"),
  Preset(emoji: "🥗", name: "Comida cetogénica"),
  Preset(emoji: "🥗", name: "Comida con una porción grande de ensalada"),
  Preset(emoji: "💪", name: "Hacer algo que me de miedo", isFeatured: true),
  Preset(emoji: "💪", name: "Salir de mi zona de confort", isFeatured: true),
  Preset(emoji: "🙂", name: "Pensamiento negativo", isFeatured: true),
  Preset(emoji: "🏋️‍♂️", name: "Ir al trabajo en bicicleta"),
  Preset(emoji: "🏋️‍♂️", name: "Ir al trabajo andando"),
  Preset(emoji: "🥗", name: "Día sin azúcares", isFeatured: true),
  Preset(emoji: "🏋️‍♂️", name: "Salir a correr"),
  Preset(emoji: "💪", name: "Empezar por la tarea más dura"),
  Preset(emoji: "💧", name: "Momento de reflexión e introspección al final del día"),
  Preset(emoji: "🙃", name: "Palabrotas"),
  Preset(emoji: "🙂", name: "Aguanarse las ganas de hablar mal de alguien"),
  Preset(emoji: "⏰", name: "Acostarme a las 22:30")
]


struct Tabbar: View {
  
  let store: Store<AppState, AppAction>
  @State var selection: Int = 1
  var body: some View {
    
    WithViewStore(store) { viewStore in
      
      TabView(selection: $selection) {
        
        //FavoritesScreen(store: store)
        //.navigationify()
        //.tabItem {
        //Label("Favorites", systemImage: "star")
        //}
        
        
  //      HomeScreen(store: store)
        ExploreScreen(viewStore: viewStore)
//        StackCardComponent()
          .navigationTitle("Explore")
          .navigationBarHidden(true)
          .navigationify()
          .tag(1)
          .tabItem {
            Label("All", systemImage: "list.bullet")
          }
        
      
      HomeScreen(store: store)
           .navigationTitle("Tallies")
           .navigationify()
           .tag(2)
           .tabItem {
             Label("All", systemImage: "list.bullet")
           }
        
        //AddGoalScreen(store: store)
        //.navigationify()
        //.tabItem {
        //Label("Goals", systemImage: "flag")
        //}
        
  //
  //      GoalsScreen(store: store)
  //        .navigationTitle("Goals")
  //        .navigationBarTitleDisplayMode(.inline)
  //        .navigationify()
  //        .tabItem {
  //          Label("Goals", systemImage: "flag")
  //        }
  //
  //      ArchivedScreen(store: store)
  //        .navigationify()
  //        .tabItem {
  //          Label("Archived", systemImage: "archivebox")
  //        }
      }
      .introspectTabBarController { tabbarController in
        tabbarController.tabBar.isHidden = true
      }
      .overlay(
        VStack {
          HStack {
            
            Spacer()
            Image(systemName: "plus.rectangle.fill")
              .foregroundColor(selection == 1 ? WindColor.blue.c500 : WindColor.neutral.c500)
              .onTap {
                selection = 1
              }
            Spacer()
            Image(systemName: "list.number")
              .foregroundColor(selection == 2 ? WindColor.blue.c500 : WindColor.neutral.c500)
              .onTap {
                selection = 2
              }
            
            Spacer()
          }
          .padding()
        }
        .animation(.spring(), value: selection)
        .maxWidth(.infinity)
        .background(.thinMaterial)
        .zIndex(0)
        .displayIf(viewStore.state.tabbarIsHidden),
        alignment: .bottom
      )
    }
      
    }
}

