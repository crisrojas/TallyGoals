import ComposableArchitecture
import SwiftUI

struct BehaviourEditScreen: View {
  
  @Environment(\.presentationMode) var presentationMode
  let viewStore: AppViewStore
  let item: Behaviour
  
  @State var emoji: String
  @State var name: String
  @State var count: Int = .zero
  
  var body: some View {
//    WithViewStore(store) { viewStore in
      VStack {
        Form { 
          
          Section { 
            TextField("", text: $emoji)
              .onChange(of: emoji) { newValue in
                emoji = String(newValue.prefix(1))
              }
            TextField("", text: $name)
          } footer: { 
            HStack(spacing: 12) {
              Spacer()
              Text(count.string)
                .font(.caption)
              HStack {
                Text("-")
                  .onTap {
                    guard count > 0 else { return }
                    count -= 1
                  }
                Divider()
                  .accentColor(Color.blue100)
                Text("+")
                  .onTap {
                    count += 1
                  }
              }
              .height(20)
              .horizontal(8)
              .foregroundColor(Color.blue500)
              .background(Color.blue100.cornerRadius(10))
            }
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
//    }
  }
  
  func pop() {
    presentationMode.wrappedValue.dismiss()
  }
}
