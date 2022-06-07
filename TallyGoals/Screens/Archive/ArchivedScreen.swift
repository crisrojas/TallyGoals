import ComposableArchitecture
import SwiftUI

struct ArchivedScreen: View {
  
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      
      switch viewStore.state.behaviourState {
      case .idle, .loading:
        ProgressView()
      case .success(let model):
        let model = getArchived(from: model)
        
        if model.isEmpty {
          ListEmptyView(symbol: "archivebox")
        } else { 
//          List(model) { item in
//            ListRow(
//              store: store,
//              item: item,
//              archive: true
//            )
//              .allowsHitTesting(false)
//              .swipeActions {
//                Label("Unarchive", systemImage: "archivebox")
//                  .onTap {
//                    withAnimation(.default) {
//                      viewStore.send(.updateArchive(
//                        id: item.id,
//                        archive: false
//                      ))
//                    }
//                  }
//                  .tint(.gray)
//
//                Button(role: .destructive) {
//                  withAnimation {
//                    viewStore.send(.deleteBehaviour(id: item.id))
//                  }
//                } label: {
//                  Label("Delete", systemImage: "trash.fill")
//                }
//              }
//          }
//          .navigationTitle("Archived")
        }
      case .empty:
        Text("No items yet")
      case .error(let message):
        Text(message)
      }
    }
  } 
  
  func getArchived(from behaviourList: [BehaviourEntity]) -> [BehaviourEntity] {
    behaviourList.filter { $0.archived }
  }
}
