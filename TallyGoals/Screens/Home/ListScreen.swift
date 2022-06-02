import ComposableArchitecture
import CoreData
import SwiftUI
import SwiftUItilities
import SwiftWind

struct ListScreen: View {
  
  let store: Store<AppState, AppAction>
  
  var body: some View {
    
    WithViewStore(store) { viewStore in
      
      VStack {
        switch viewStore.state.behaviourState {
        case .idle, .loading:
          progressView(viewStore: viewStore)
        case .success(let model):
          
//          successView(model: model, viewStore: viewStore)
          
          DefaultVStack {

            DefaultVStack {
              Text("Pinned")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.bold)
                .alignX(.leading)

              BehaviourGrid(
                model: model.pinnedFilter,
                store: store
              )
              .top(.s4)
            }
            .top(.s6)
            .horizontal(.horizontal)
            .displayIf(model.pinnedFilter.isNotEmpty)
            
            Text("List")
              .font(.system(.subheadline, design: .rounded))
              .fontWeight(.bold)
              .alignX(.leading)
              .horizontal(.horizontal)
              .displayIf(model.pinnedFilter.isNotEmpty)
              .top(.s6)

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
          }
          .scrollify()
          
        case .empty:
          emptyView
        case .error(let message):
          Text(message)
        }
      }
      .toolbar {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
          
          if viewStore.state.isEditingMode {
            Text("DONE")
              .font(.caption2)
              .fontWeight(.black)
              .foregroundColor(.blue500)
              .vertical(5)
              .horizontal(8)
              .background(
                Color.blue100.cornerRadius(16)
              )
              .onTap {
                viewStore.send(
                  .toggleEditingMode(value: false)
                )
              }
          } else {
            
            Image(systemName: "plus")
              .onTap {
                AddScreen(store: store)
              }
            
          }
        }
      }
            .onTapGesture {
              print("tapped list screen")
              NotificationCenter.collapseRowList()
            }
      
    }
  }
}

// MARK: - @todo: Legacify
extension ListScreen {
  func progressView
  (viewStore: AppViewStore) -> some View {
    ProgressView()
      .onAppear {
        viewStore.send(.readBehaviours)
      }
  }
  
  func successView
  (model: [Behaviour], viewStore: AppViewStore) -> some View {
    
    List {
      Section {
        ForEach(model.defaultFilter) { item in
          ListRow(
            store: store,
            item: item
          )
//            .buttonStyle(PlainButtonStyle())
            .swipeActions(edge: .trailing) {
              trailingSwipeActions(
                viewStore: viewStore,
                id: item.id
              )
            }
            .swipeActions(edge: .leading) {
              Label("Pin", systemImage: "pin")
                .onTap {
                  withAnimation {
                    viewStore.send(
                      .updatePinned(
                        id: item.id,
                        pinned: !item.pinned
                      )
                    )
                  }
                }
                .tint(item.pinned ? .gray : .indigo)
            }
        }
      } header: {
        BehaviourGrid(
          model: model.pinnedFilter,
          store: store
        )
      }
    }
    .listStyle(GroupedListStyle())
  }
}


// MARK: - UI components
private extension ListScreen {
  
  var emptyView: some View {
    Text("No items")
  }
  
  @ViewBuilder
  func trailingSwipeActions
  (viewStore: AppViewStore, id: NSManagedObjectID)-> some View {
    
    Label("Archive", systemImage: "archivebox")
      .onTap {
        withAnimation(.default) {
          viewStore.send(.updateArchive(
            id: id,
            archive: true
          ))
        }
      }
      .tint(.orange)
    
    Button(role: .destructive) {
      viewStore.send(.deleteBehaviour(id: id))
    } label: {
      Label("Delete", systemImage: "trash.fill")
    }
  }
  
  func getCount
  (behaviourId: NSManagedObjectID, viewStore: AppViewStore) -> Int {
    viewStore
      .entries
      .filter { $0.behaviourId == behaviourId }
      .count
  }
}

