import ComposableArchitecture
import CoreData
import SwiftUI
import SwiftUItilities
import SwiftWind

struct LegacyBehaviourCard: View {
  
  @State var showEdit: Bool = false
  
  let model: Behaviour
  let store: AppStore
  
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
            ), color: model.color)
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
//      .background(editLink)
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
  
//  var editLink: some View {
//    EmptyNavigationLink(
//      destination: behaviourEditScreen,
//      isActive: $showEdit
//    )
//  }
  
//  var behaviourEditScreen: some View {
//    BehaviourEditScreen(
//      store: store,
//      item: model,
//      emoji: model.emoji,
//      name: model.name
//    )
//  }
  
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
  let color: WindColor
  let small: Bool
  let dark: Bool
  
  init(number: Int, color: WindColor, small: Bool = false, dark: Bool = true) {
    self.number = number
    self.color = color
    self.small = small
    self.dark = dark
  }
  
  var body: some View {
    Circle()
      .foregroundColor(dark ? color.c500 : color.c100)
      .size(small ? .s4 : .s5)
      .shadow(
        color: small ? color.c200 : color.c300,
        radius: small ? .px : .s1,
        x:  small ? .px : .s05,
        y:  small ? .px : .s05
      )
      .overlay(
        Text(number.string)
          .font(small ? .caption2 : .caption)
          .fontWeight(.bold)
          .foregroundColor(dark ? color.c50 : color.c500)
      )
  }
}
