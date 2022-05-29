import Combine
import ComposableArchitecture
import SwiftUI

struct AddScreen: View {
  @Environment(\.presentationMode) var presentationMode
  let store: Store<AppState, AppAction>
  
  @State var emoji: String = ""
  @State var name : String = ""
  @State var goal : String = ""
  @State var color: String = ""
  
  var body: some View {
    WithViewStore(store) { viewStore in
      
      Form {
        
        EmojiField("Emoji", text: $emoji)
        TextField("Name",   text: $name)
        TextField("Goal",   text: $goal)
        TextField("Color",  text: $color)
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

struct EmojiField: View {
  @Binding var text: String
  let placeholder: String
  
  init(
    _ placeholder: String,
    text: Binding<String>
  ) {
    self._text = text
    self.placeholder = placeholder
  }
  
  var body: some View {
    TextField("Emoji", text: $text)
      .onChange(of: text) { newValue in
        text = String(newValue.prefix(1))
      }
  }
}
