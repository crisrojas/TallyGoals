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
          
          VStack {
            
            if model.pinnedFilter.isNotEmpty {
              BehaviourGrid(
                model: model.pinnedFilter,
                store: store
              )
                .horizontal(24)
                .top(24)
            }
            
            LazyVStack(spacing: 0) {
              ForEach(model.defaultFilter) { item in
                //Row(model: item, store: store)
                
                NewRow(model: item, color: .blue)
                
              }
            }
            .background(Color(UIColor.systemBackground))
            .top(8)
            .bottom(24)
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
          
          if viewStore.state.isEditingPinned {
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
                viewStore.send(.stopEditingPinned)
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
            .buttonStyle(PlainButtonStyle())
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
  
  
  @ViewBuilder
  func rowBackground(pinned: Bool) -> some View {
    
    if pinned {
      Color.indigo
        .opacity(0.3)
    } else {
      Color.gray
        .opacity(0.15)
    }
  }
}

extension Array where Element == Behaviour {
  
  var defaultFilter: Self {
    self
      .filter { !$0.archived }
      .filter { !$0.pinned }
      .sorted(by: { $0.name < $1.name })
      .sorted(by: { $0.emoji < $1.emoji })
    //.sorted(by: { $0.pinned && !$1.pinned })
  }
  
  var pinnedFilter: Self {
    self
      .filter { !$0.archived }
      .filter { $0.pinned }
      .sorted(by: { $0.name < $1.name })
      .sorted(by: { $0.emoji < $1.emoji })
    
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
    
    
    //Label("Favorite", systemImage: "star.fill")
    //.onTap { 
    //viewStore.send(.updateFavorite(
    //id: id,
    //favorite: true
    //))
    //}
    //.tint(.yellow)
  }
  
  func getCount
  (behaviourId: NSManagedObjectID, viewStore: AppViewStore) -> Int {
    viewStore
      .entries
      .filter { $0.behaviourId == behaviourId }
      .count
  }
}

