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
           
//            EmojiField("", text: $emoji)

            DefaultVStack {
//              Text("Pinned")
//                .font(.system(.subheadline, design: .rounded))
//                .fontWeight(.bold)
//                .alignX(.leading)
//            b  .horizontal(.horizontal)

              BehaviourGrid(
                model: model.pinnedFilter,
                store: store
              )
//              .top(.s4)
            }
            .top(.s6)
            .displayIf(model.pinnedFilter.isNotEmpty)
            
//            Text("List")
//              .font(.system(.subheadline, design: .rounded))
//              .fontWeight(.bold)
//              .alignX(.leading)
//              .horizontal(.horizontal)
//              .displayIf(
//                model.pinnedFilter.isNotEmpty &&
//                model.defaultFilter.isNotEmpty
//              )
//              .top(.s6)

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
    Text("No items")
  }
}

