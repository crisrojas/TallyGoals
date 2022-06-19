import Algorithms
import ComposableArchitecture
import CoreData
import SwiftUI
import SwiftUItilities
import SwiftWind

struct HomeScreen: View {
  
  let store: Store<AppState, AppAction>
  @State var emoji = ""
  var body: some View {
    
    WithViewStore(store) { viewStore in
      
      VStack {
        switch viewStore.state.behaviourState {
        case .idle, .loading:
          progressView(viewStore: viewStore)
        case .success(let model):
          
          
          DefaultVStack {
            
            BehaviourGrid(
              model: model.pinnedFilter,
              store: store
            )
            .top(.s6)
            .displayIf(model.pinnedFilter.isNotEmpty)
            
              LazyVStack(spacing: 0) {
                ForEach(model.defaultFilter) { item in
                  BehaviourRow(
                    model: item,
                    viewStore: viewStore
                  )
                }
              }
              .background(Color.behaviourRowBackground)
              .top(model.pinnedFilter.isEmpty ? .zero : .s4)
              .bottom(.s6)
              .animation(.easeInOut, value: model.defaultFilter)
            
            
          }
          .scrollify()
          .onTapDismissKeyboard()
          .overlay(
            emptyView.displayIf(model.defaultFilter.isEmpty && model.pinnedFilter.count <= 3)
          )
          
        case .empty:
          emptyView
        case .error(let message):
          Text(message)
        }
      }
      .toolbar {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
          Image(systemName: "plus")
            .onTap {
              AddScreen(store: store)
            }
        }
      }
    }
  }
}


// MARK: - UI components
private extension HomeScreen {
  
  func progressView
  (viewStore: AppViewStore) -> some View {
    ProgressView()
      .onAppear {
        viewStore.send(.readBehaviours)
      }
  }
  
  var emptyView: some View {
    ListEmptyView(symbol: "house")
  }
}

