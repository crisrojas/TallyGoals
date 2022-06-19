import Combine
import ComposableArchitecture
import SwiftUI

struct AddScreen: View {
  @Environment(\.presentationMode) var presentationMode
  let store: Store<AppState, AppAction>
  
  @State var emoji: String = ""
  @State var name : String = ""
  
  var body: some View {
    WithViewStore(store) { viewStore in
      
      Form {
        
        EmojiTextField("Emoji", text: $emoji)
        TextField("Name",   text: $name)
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
    .onTapDismissKeyboard()
  }
  
  func pop() {
    presentationMode.wrappedValue.dismiss()
  }
}

