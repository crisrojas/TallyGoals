import Combine
import ComposableArchitecture
import SwiftUI

struct AddScreen: View {
  @Environment(\.presentationMode) var presentationMode
  let store: Store<AppState, AppAction>
  
  @State var emoji: String = ""
  @State var name: String = ""
  @State var goal: String = ""
  
  var body: some View {
    WithViewStore(store) { viewStore in
      
      Form {
        TextField("Emoji", text: $emoji)
          .onChange(of: emoji) { newValue in
            emoji = String(newValue.prefix(1))
          }
        TextField("Name", text: $name)
        TextField("Goal", text: $goal)
      }
      .toolbar { 
        
        Text("Add")
          .onTap {
            viewStore.send(
              .createBehaviour(
                emoji: emoji, 
                name: name,
                completion: pop
              )
            )
          }
          .disabled(
            emoji.isEmpty || name.isEmpty
          )
      }
      
    }
  }
  
  func pop() {
    presentationMode.wrappedValue.dismiss()
  }
}
