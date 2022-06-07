import ComposableArchitecture
import SwiftUI
import SwiftUItilities
import SwiftWind

struct Sequence {
  let behaviours: [BehaviourItem]
}

struct BehaviourItem {
  let behaviour: Behaviour
  let time: Double
}




struct Tabbar: View {
  
  let store: Store<AppState, AppAction>
  
  var body: some View {
    
//    TabView {
      
      //FavoritesScreen(store: store)
      //.navigationify()
      //.tabItem {
      //Label("Favorites", systemImage: "star")
      //}
      
      
      HomeScreen(store: store)
   
//    AddScreen(store: store)
        .navigationTitle("Tallies")
//        .navigationBarTitleDisplayMode(.inline)
        .navigationify()
        .tabItem { 
          Label("All", systemImage: "list.bullet")
        }
      
      //AddGoalScreen(store: store)
      //.navigationify()
      //.tabItem {
      //Label("Goals", systemImage: "flag")
      //}
      
//      Tab()
//        .navigationTitle("Sequences")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationify()
//        .tabItem {
//          Label("Sequences", systemImage: "list.bullet")
//        }
//
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
//    }
  }
}

