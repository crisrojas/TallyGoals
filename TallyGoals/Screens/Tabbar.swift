import ComposableArchitecture
import SwiftUI
import SwiftUItilities
import SwiftWind

struct Sequence {
  let behaviours: [BehaviourItem]
}

struct BehaviourItem {
  let behaviour: Behaviour
  let time: Double
}


struct CustomList<Content: View, T: Identifiable>: View {
  
  @State var id: UUID?
  let model: [T]
  let cell: (UUID?, T) -> Content
  
  init(_ model: [T], content: @escaping (UUID?, T) -> Content) {
    self.model = model
    self.cell = content
  }
  
  var body: some View {
    LazyVStack() {
      ForEach(model) { item in
        cell(id, item)
      }
    }
  }
}

extension String: Identifiable {
  public var id: String { self }
}

struct Test: View {
  let array = ["item 1", "item2", "item3"]
  
  var body: some View {
    CustomList(array) { id, item in
        Text(item)
        .padding()
        .frame(maxWidth: .infinity)
        .swipeActions(leading: leadingActions)
        
    }
  }
  
  var leadingActions: [SwipeAction] {
    [
      SwipeAction(
        label: "Action 1",
        systemSymbol: "pin.fill",
        action: { print("pin") },
        backgroundColor: .red100,
        tintColor: .white),
      SwipeAction(
        label: "Action 2",
        systemSymbol: "pencil",
        action: { print("edit") },
        backgroundColor: .yellow,
        tintColor: .white),
      SwipeAction(
        label: "Action 2",
        systemSymbol: "minus",
        action: { print("decrease") },
        backgroundColor: .green,
        tintColor: .white),
    ]
  }
}

struct Tab: View {
  
  @GestureState var isPressing = false
  @State var translation: CGSize = .zero
  @State var width: CGFloat = .zero
  
  var body: some View {
    VStack {
      
      Color(uiColor: .secondarySystemBackground)
        .aspectRatio(312/500, contentMode: .fit)
        .cornerRadius(24)
        .overlay(
          VStack() {
            Text("👔")
              .font(.largeTitle) 
            Text("x1")
              .font(.caption)
            
            Text("Planchar ropa título largo dfdfdfdfddf")
              .multilineTextAlignment(.center)
              .font(.body)
              .top(12)
          }
        )
        .overlay(
          HStack(spacing: 24) {
            Image(systemName: isPressing ? "x.circle.fill" : "x.circle")
              .resizable()
              .size(40)
              .foregroundColor(.red)
              .scaleEffect(isPressing ? 0.8 : 1)
              .animation(.easeInOut(duration: 0.15), value: isPressing)
              .highPriorityGesture(
                TapGesture()
                  .onEnded { _ in
                    print("@todo")
                  }
              )
              .simultaneousGesture(
                LongPressGesture()
                  .updating($isPressing) { currentState, gestureState, transaction in
                    gestureState = currentState
                  }
                  .onEnded { _ in
                    print("Ended")
                  }
              )
            
            Image(systemName: "checkmark.circle")
              .resizable()
              .size(40)
              .foregroundColor(.green)
          }
            .y(-20)
          , alignment: .bottom
        )
        .horizontal(24)
        .x(translation.width)
        .y(translation.height)
        .rotationEffect(.degrees(translation.width / 200) * 25, anchor: .bottom)
        .gesture(
          DragGesture()
            .onChanged { value in
              translation = value.translation
            }
            .onEnded { _ in
              withAnimation {
                translation = .zero
              }
            }
        )
      
      
      
    }
  }   
}


struct TestingWind: View {
  
  var body: some View {
    VStack {
      Rectangle()
        .size(200)
        .foregroundColor(WindColor.tertiary.c900)
    }
  }
}
struct Tabbar: View {
  
  //    let persistence = Persistence.previewFull
  let store: Store<AppState, AppAction>
  
  var body: some View {
    
//    TabView {
      
      //FavoritesScreen(store: store)
      //.navigationify()
      //.tabItem {
      //Label("Favorites", systemImage: "star")
      //}
      
      
      ListScreen(store: store)
        .navigationTitle("Tallies")
//        .navigationBarTitleDisplayMode(.inline)
        .navigationify()
        .tabItem { 
          Label("All", systemImage: "list.bullet")
        }
      
      //AddGoalScreen(store: store)
      //.navigationify()
      //.tabItem {
      //Label("Goals", systemImage: "flag")
      //}
      
//      Tab()
//        .navigationTitle("Sequences")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationify()
//        .tabItem {
//          Label("Sequences", systemImage: "list.bullet")
//        }
//
//
//      GoalsScreen(store: store)
//        .navigationTitle("Goals")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationify()
//        .tabItem {
//          Label("Goals", systemImage: "flag")
//        }
//
//      ArchivedScreen(store: store)
//        .navigationify()
//        .tabItem {
//          Label("Archived", systemImage: "archivebox")
//        }
//    }
  }
}

