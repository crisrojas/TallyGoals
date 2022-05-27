import ComposableArchitecture
import CoreData
import SwiftUI
import SwiftUItilities

struct BehaviourCard: View {
  
  let model: Behaviour
  let store: AppStore
  @State var showEdit: Bool = false
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(alignment: .leading) {
        Rectangle()
          .foregroundColor(Color(UIColor.secondarySystemBackground))
          .size(80)
          .cornerRadius(8)
          .overlay(Text(model.emoji))
          .overlay(
            
            Badge(number: getCount(
              behaviourId: model.id, 
              viewStore: viewStore
            ))
              .x(10)
              .y(-10)
            ,
            alignment: .topTrailing
            
          )
          .onTap {
            viewStore.send(.addEntry(behaviour: model.id))
          }
        
        
        Text(model.name)
          .width(80)
          .font(.caption)
          .lineLimit(2)
          .fixedSize(
            horizontal: false, 
            vertical: true
          )
          .height(40)
        
      }
      .background(editLink)
      .contextMenu {
        Label("Edit", systemImage: "pencil")
          .onTap {
            showEdit = true
          }
        Label("Unpin", systemImage: "pin")
          .onTap {
            viewStore.send(.updatePinned(id: model.id, pinned: false))
          }
      }
    }
  }
  
  var editLink: some View {
    EmptyNavigationLink(
      destination: behaviourEditScreen,
      isActive: $showEdit
    )
  }
  
  var behaviourEditScreen: some View {
    BehaviourEditScreen(
      store: store,
      item: model, 
      emoji: model.emoji, 
      name: model.name
    )
  }
  
  func getCount
  (behaviourId: NSManagedObjectID, viewStore: AppViewStore) -> Int {
    viewStore
      .entries
      .filter { $0.behaviourId == behaviourId }
      .count
  }
}

struct Badge: View {
  let number: Int
  var body: some View {
    Circle()
      .foregroundColor(.blue500)
      .size(20)
      .shadow(radius: 4)
      .overlay(
        Text(number.string)
          .font(.caption)
          .fontWeight(.bold)
          .foregroundColor(.blue50)
      )
  }
}
