import ComposableArchitecture
import SwiftUI

struct BehaviourEditScreen: View {
  
  @Environment(\.presentationMode) var presentationMode
  let viewStore: AppViewStore
  let item: Behaviour
  
  @State var emoji: String
  @State var name: String
  
  var body: some View {
      VStack {
      
        Form { 
          
          Section { 
            TextField("", text: $emoji)
              .onChange(of: emoji) { newValue in
                emoji = String(newValue.prefix(1))
              }
            TextField("", text: $name)
          }
        }
        
      }
      .toolbar { 
        Text("Save")
          .onTap {
            viewStore.send(
              .updateBehaviour(
                id: item.id, 
                emoji: emoji,
                name: name,
                completion: pop
              )
            )
          }
          .disabled(
            emoji == item.emoji && name == item.name
          )
      }
  }
  
  func pop() {
    presentationMode.wrappedValue.dismiss()
  }
}
