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
  
  let store: Store<AppState, AppAction>
  
  var body: some View {
    
//    TabView {
      
      //FavoritesScreen(store: store)
      //.navigationify()
      //.tabItem {
      //Label("Favorites", systemImage: "star")
      //}
      
      
      HomeScreen(store: store)
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

