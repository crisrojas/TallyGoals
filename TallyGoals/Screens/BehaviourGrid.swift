import ComposableArchitecture
import SwiftUI
import SwiftUItilities
import SwiftWind

struct VerticalLinearGradient: View {
  let colors: [Color]
  var body: some View {
    LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
  }
}

struct BehaviourGrid: View {
  
  let model: [Behaviour]
  let store: AppStore
  
  private let columns = [
    GridItem(.flexible(), spacing: 0),
    GridItem(.flexible(), spacing: 0),
    GridItem(.flexible(), spacing: 0)
  ]
  
  var body: some View {
    WithViewStore(store) { viewStore in
      LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
        ForEach(model) { item in
          BehaviourCardBis(model: item, viewStore: viewStore)
//          CardView(
//            model: item,
//            store: store
//          )
         
   
//          .height(.s10)
        }
      }
      .onReceive(NotificationCenter.collapseRowNotification) { _ in
        print("Editing shouwld be false")
//        withAnimation {
//          viewStore.send(.stopEditingPinned)
//        }
      } 
    }
  }
}

struct BehaviourCardBis: View {
  
  let model: Behaviour
  let viewStore: AppViewStore
  @State var count: Int = .zero
  @State var isEditing = false
  @State var showEditingScreen = false
  @State var offset: CGFloat = .zero
  
  var body: some View {
      background
//      .cornerRadius(.s5)
      .aspectRatio(1, contentMode: .fill)
      .overlay(
        Text(model.emoji)
        .font(.caption)
        .padding()
        , alignment: .topTrailing
      )
      .overlay(chevronIcon, alignment: .topLeading)
      .overlay(labelStack, alignment: .bottomLeading)
      .simultaneusLongGesture(perform: toggleEditing)
      .highPriorityTapGesture(perform: highPriorityAction)
      .navigationLink(editScreen, $showEditingScreen)
      .onReceive(NotificationCenter.collapseRowNotification) { _ in
        withAnimation {
         isEditing = false
        }
      }
    
    .background(background)
    .overlay(editingView)
    .gesture(
      DragGesture()
        .onEnded { value in
         let width = value.translation.width
          
          if width < -10 {
            isEditingView = true
          }
          
          if width > 10 {
            isEditingView = false
          }
        }
    )
  }
    
  @State var isEditingView = false
    var editingView: some View {
      WindColor.gray.c600.opacity(0.8)
      .displayIf(isEditingView)
    }
  
  var chevronIcon: some View {
    Image(systemName: "chevron.right")
    .foregroundColor(WindColor.gray.c400)
    .padding(.s3)
    .displayIf(viewStore.state.isEditingMode)
  }
  
  var labelStack: some View {
    DefaultVStack {
      Text(count.string)
        .fontWeight(.bold)
        .font(.system(.title2, design: .rounded))
      Text(model.name)
        .fontWeight(.bold)
        .font(.system(.caption, design: .rounded))
        .lineLimit(2)
    }
    .foregroundColor(WindColor.zinc.c700)
    
    .padding(.s3)
  }
  
  var editScreen: some View {
    BehaviourEditScreen(
      viewStore: viewStore,
      item: model,
      emoji: model.emoji,
      name: model.name
    )
  }
  
  @ViewBuilder
  var background: some View {
    if isEditing {
      VerticalLinearGradient(colors: [
        WindColor.red.c100,
        WindColor.red.c200
      ])
    } else {
      VerticalLinearGradient(colors: [
        WindColor.zinc.c100,
        WindColor.zinc.c200
      ])
    }
  }
  
  func toggleEditing() {
    guard !viewStore.state.isEditingMode else { return }
    isEditing.toggle()
  }
  
  func highPriorityAction() {
    
    guard !viewStore.state.isEditingMode else {
      showEditingScreen = true
      viewStore.send(.toggleEditingMode(value: false))
      return
    }
    
    if isEditing {
      decrease()
    } else {
      increase()
    }
  }
  
  func decrease() {
    guard count > 0 else { return }
    count -= 1
  }
  
  func increase() {
    count += 1
  }
}

struct CardView: View {
  
  @GestureState var isPressing = false
  @State var isAnimating = false
  @State var isDialogPresented = false
  @State var isScaling = false
  
  let model: Behaviour
  let store: AppStore
  
  var body: some View {
    WithViewStore(store) { viewStore in
      Group {
        
        ZStack {
          
          Card(
            emoji: model.emoji,
            name: model.name,
            color: .blue,
            behaviourId: model.id,
            viewStore: viewStore,
            showCount: true
          )
            .opacity(viewStore.state.isEditingPinned ? 0 : 1)
            .opacity(isPressing ? 0.1 : 1)
            .scaleEffect(isPressing ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.2).repeatCount(1, autoreverses: true), value: isPressing)
            .highPriorityGesture(
              TapGesture().onEnded {
                viewStore.send(.addEntry(behaviour: model.id))
              }
            )
            .simultaneousGesture(
              LongPressGesture(minimumDuration: 0.8, maximumDistance: 1)
                .updating($isPressing) { currentState, gestureState, transaction in
                  gestureState = currentState
                }
                .onEnded { _ in
                  
                  withAnimation { 
                    viewStore.send(.startEditingPinned)
                  }
                }
            )
          
          if viewStore.state.isEditingPinned {
            BlinkinCard(
              model: model, 
              store: store
            )
          }
        }
      }
    }
  }
  
  var regularComponent: some View {
    VStack {
      
      Rectangle()
        .fill(Color(uiColor: .secondarySystemBackground))
        .size(80)
        .cornerRadius(12)
        .overlay(
          Text(model.emoji)
        )
      
      let name = model.name.count < 12 ? model.name + "\n" : model.name
      Text(name)
        .font(.caption2)
        .multilineTextAlignment(.center)
        .lineLimit(2)
        .fixedSize(
          horizontal: false, 
          vertical: true
        )
    }
    .opacity(isPressing ? 0.05 : 1)
    
  }
  
  var blinkingComponent: some View {
    regularComponent
      .overlay(deleteButton, alignment: .topLeading)
      .rotate(isAnimating ? 4 : 0)
      .animation(
        Animation.linear(duration: 0.1).repeatForever(), 
        value: isAnimating
      )
      .onAppear {
        isAnimating = true
      }
  }
  
  @ViewBuilder
  var deleteButton: some View {
    Circle()
      .foregroundColor(.gray200)
      .size(20)
      .overlay(
        Text("—")
          .font(.caption)
          .foregroundColor(.black)
          .fontWeight(.bold)
          .y(-1)
      )
      .x(-6)
      .y(-6)
      .onTapGesture {
        isDialogPresented = true
        print("Delete")
      }
  }
  
}

struct BlinkinCard: View {
  
  @State var isAnimating = false
  @State var isPresentingDialog = false
  @State var showEditView = false
  @State var showDeletingAlert = false
  
  let model: Behaviour
  let store: AppStore
  
  var body: some View {
    
    WithViewStore(store) { viewStore in
      Card(
        emoji: model.emoji,
        name: model.name,
        color: .gray,
        behaviourId: model.id,
        viewStore: viewStore,
        showCount: false
      )
        .overlay(deleteButton, alignment: .topLeading)
        .rotate(isAnimating ? 4 : 0)
        .animation(
          Animation.linear(duration: 0.1).repeatForever(), 
          value: isAnimating
        )
//        .navigationLink(editScreen, $showEditView)
        .onTap {
          showEditView = true
        }
        .buttonStyle(.plain)
        .onAppear {
          isAnimating = true
        }
        .alert(isPresented: $showDeletingAlert) {
          Alert(
            title: Text("Are you sure you want to delete the item?"), 
            message: Text("This action cannot be undone"), 
            primaryButton: .destructive(Text("Delete"), action: { viewStore.send(.deleteBehaviour(id: model.id))}),
            secondaryButton: .default(Text("Cancel"))
          )
        }
        .confirmationDialog("Edit", isPresented: $isPresentingDialog, titleVisibility: .hidden) { 
          Button("Delete", role: .destructive) {
            showDeletingAlert = true
          }
          
          Button("Unpin") {
            
            withAnimation {
              viewStore.send(.stopEditingPinned)
              viewStore.send(.updatePinned(id: model.id, pinned: false))
            }
          }
          
          Button("Archive") {
            viewStore.send(.stopEditingPinned)
            viewStore.send(.archive(id: model.id))
          }
        }
    }
  }
  
  
  @ViewBuilder
  var deleteButton: some View {
    Circle()
      .foregroundColor(.gray200)
      .size(20)
      .overlay(
        Text("—")
          .font(.caption)
          .foregroundColor(.black)
          .fontWeight(.bold)
          .y(-1)
      )
      .x(-6)
      .y(-6)
      .onTapGesture {
        //isEditing = false
        isPresentingDialog = true
        print("Delete")
      }
  }
  
//  var editScreen: some View {
//    BehaviourEditScreen(
//      store: store,
//      item: model,
//      emoji: model.emoji,
//      name: model.name
//    )
//  }
  
}

struct Card: View {
  
  let emoji: String
  let name: String
  let color: WindColor
  let behaviourId: NSManagedObjectID
  let viewStore: AppViewStore
  let showCount: Bool
  
  var safeName: String {
    name.count < 15 ? name + "\n" : name
  }
  
  var body: some View {
    
    VStack {
      
      Rectangle()
        .fill(color.c100)
        .size(80)
        .cornerRadius(12)
        .overlay(Text(emoji))
        .overlay(badge(viewStore), alignment: .topTrailing)
      
//      Text(safeName)
//        .font(.caption2)
//        .multilineTextAlignment(.center)
//        .lineLimit(1)
//        .fixedSize(
//          horizontal: false,
//          vertical: true
//        )
    }
  }
  
  
  func badge(_ viewStore: AppViewStore) -> some View {
    Badge(number: getCount(
      behaviourId: behaviourId,
      viewStore: viewStore
    ), color: WindColor.blue)
      .x(.s2)
      .y(-.s2)
      .displayIf(showCount)
  }
}

extension View {
  func rotate(_ angles: Double) -> some View {
    self.rotationEffect(Angle(degrees: angles))
  }
}

import CoreData
func getCount
(behaviourId: NSManagedObjectID, viewStore: AppViewStore) -> Int {
  viewStore
    .entries
    .filter { $0.behaviourId == behaviourId }
    .count
}
