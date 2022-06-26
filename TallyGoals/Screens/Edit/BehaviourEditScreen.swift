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
            TextField("Emoji", text: $emoji)
              .onChange(of: emoji) { newValue in
                emoji = String(newValue.prefix(1))
              }
            TextField("Titre", text: $name)
          }
        }
        
      }
      .toolbar { 
        Text("Enregistrer")
          .onTap {
            viewStore.send(
              .updateBehaviour(
                id: item.id, 
                emoji: emoji,
                name: name
              ))
            pop()
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
