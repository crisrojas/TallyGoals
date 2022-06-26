import ComposableArchitecture
import SwiftUI
import SwiftUItilities
import SwiftWind

struct Tabbar: View {
  
  let store: Store<AppState, AppAction>
  @State var selection: Int = 0
  var body: some View {
    
    WithViewStore(store) { viewStore in
      
      TabView(selection: $selection) {
        
        
        HomeScreen(store: store)
          .navigationTitle("Tallies")
          .navigationify()
          .tag(0)
          .tabItem {
            Label("Home", systemImage: "house")
          }
        
        ExploreScreen(viewStore: viewStore)
          .navigationTitle("Explore")
          .navigationify()
          .tag(1)
          .tabItem {
            Label("Explore", systemImage: "plus.rectangle.fill")
          }
        
        ArchivedScreen(store: store)
          .navigationTitle("Archive")
          .navigationify()
          .tag(2)
          .tabItem {
            Label("Archived", systemImage: "archivebox")
          }
      }
      .overlay(overlay(viewStore: viewStore))
    }
  }
  
  @ViewBuilder
  func overlay(viewStore: AppViewStore) -> some View {
    switch viewStore.state.overlay {
    case .exploreDetail(let category):
      PresetCategoryDetailScreen(model: category, viewStore: viewStore)
    case .error(let title, let message):
      ErrorView(title: title, message: message, viewStore: viewStore)
    case .none:
      EmptyView()
    }
  }
}


// @todo: change each string
