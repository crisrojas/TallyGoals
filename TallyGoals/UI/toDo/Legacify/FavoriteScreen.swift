import ComposableArchitecture
import SwiftUI

struct FavoritesScreen: View {
  
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      
      switch viewStore.behaviourState {
      case .idle, .loading:
        ProgressView()
          .onAppear {
            viewStore.send(.readBehaviours)
          }
      case .success(let model):
        let model = getFavorites(from: model)
        
        if model.isEmpty {
          ListEmptyView(symbol: "star.fill")
        } else {
          List(model, id: \.id) { item in
            ListRow(
              store: store,
              item: item
            )
              .onTap {
                withAnimation {
                  viewStore.send(
                    .addEntry(behaviour: item.objectID)
                  )
                }
              }
              .buttonStyle(.plain)
              .swipeActions(edge: .trailing) {
                swipeActionStack(
                  viewStore: viewStore,
                  item: item
                )
              }
              .swipeActions(edge: .leading) {
                Label("Pin", systemImage: "pin")
                  .onTap {
                    withAnimation {
                      viewStore.send(.updatePinned(
                        id: item.objectID,
                        pinned: !item.pinned
                      )
                      )
                    }
                  }
                  .tint(item.pinned ? .gray : .indigo)
              }
          }
          .navigationTitle("Favorites")
        }
      case .empty:
        Text("Not items yet")
      case .error(let message):
        Text(message)
      }
    }
  }
  
  @ViewBuilder
  func swipeActionStack
  (viewStore: AppViewStore, item: BehaviourEntity) -> some View {
    Label("Favorite", systemImage: "star")
      .onTap {
        viewStore.send(.updateFavorite(
          id: item.objectID,
          favorite: false)
        )
      }
      .tint(.gray)
    
    Button(role: .destructive) {
      withAnimation {
        viewStore.send(.deleteBehaviour(id: item.objectID))
      }
    } label: {
      Label("Delete", systemImage: "trash.fill")
    }
  }
  
  func getFavorites
  (from behaviourList: [BehaviourEntity]) -> [BehaviourEntity] {
    behaviourList
      .filter { $0.favorite }
      .filter { !$0.archived }
      .sorted(by: { $0.emoji! < $1.emoji! })
      .sorted(by: { $0.name! < $1.name! })
      .sorted(by: { $0.pinned && !$1.pinned })
  }
}

struct ListEmptyView: View {
  
  let symbol: String
  
  var body: some View {
    Image(systemName: symbol)
      .resizable()
      .size(50)
      .foregroundColor(.gray)
      .opacity(0.2)
  }
}
