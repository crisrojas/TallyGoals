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
          LazyVStack {
            ForEach(model) { item in
              BehaviourRow(
                model: item,
                archived: true,
                viewStore: viewStore
              )
            }
            
            Spacer()
          }
        
          .scrollify()
        }
      case .empty:
        ListEmptyView(symbol: "archivebox")
      case .error(let message):
        Text(message)
      }
    }
  } 
  
  func getArchived(from behaviourList: [Behaviour]) -> [Behaviour] {
    behaviourList.filter { $0.archived }
  }
}
