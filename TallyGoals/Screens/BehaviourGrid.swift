import Algorithms
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
  
  @State private var page: Int = .zero
  @State private var cellHeight: CGFloat = .zero
  
  let model: [Behaviour]
  let store: AppStore
  

  private let columns = [
    GridItem(.flexible(), spacing: .pinnedCellSpacing),
    GridItem(.flexible(), spacing: .pinnedCellSpacing),
    GridItem(.flexible(), spacing: .pinnedCellSpacing)
  ]
  
  private var tabViewHeight: CGFloat {
    let numberOfRows: CGFloat = 2
    return cellHeight * numberOfRows + .pinnedCellSpacing
  }
  
  private var chunkedModel: [[Behaviour]] {
    model.chunks(ofCount: 6).map(Array.init)
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      
      if model.count > 3 {
      TabView(selection: $page) {
        ForEach(0...chunkedModel.count - 1) { index in
          let chunk = chunkedModel[index]
          grid(model: chunk, viewStore: viewStore)
          .horizontal(.horizontal)
        }
       
      }
      .height(tabViewHeight)
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
      .overlay(indexView, alignment: .bottomTrailing)
    
      } else {
        grid(
          model: model,
          viewStore: viewStore,
          addFillers: false
        )
        .horizontal(.horizontal)
      }
    }
    .animation(.easeInOut, value: model)
  }
  
  var indexView: some View {
      PagerIndexView(
        currentIndex: page,
        maxIndex: chunkedModel.count - 1
      )
      .x(-.horizontal)
      .y(.s4)
      .displayIf(chunkedModel.count > 1)
  }
  
  func grid(model: [Behaviour], viewStore: AppViewStore, addFillers: Bool = true) -> some View {
    LazyVGrid(columns: columns, alignment: .leading, spacing: .pinnedCellSpacing) {
      ForEach(model) { item in
        BehaviourCardBis(model: item, viewStore: viewStore)
          .bindHeight(to: $cellHeight)
      }
     
      if addFillers {
        fills(delta: 6 - model.count)
      }
    }
  }
 
  @ViewBuilder
  func fills(delta: Int) -> some View {
    if delta > 0 {
     
      ForEach(1...delta) { _ in
        emptyCell
      }
    }
  }
  
  var emptyCell: some View {
    Color.clear
    .aspectRatio(1, contentMode: .fill)
  }
}

struct BehaviourCardBis: View {
  
  @State var showEditingScreen = false
  @State var showDeletingAlert = false
  
  let model: Behaviour
  let viewStore: AppViewStore

  var body: some View {
      background
      .cornerRadius(.s4)
      .aspectRatio(1, contentMode: .fill)
      .overlay(
        Text(model.emoji)
        .font(.caption)
        .padding()
        , alignment: .topTrailing
      )
      .overlay(chevronIcon, alignment: .topLeading)
      .overlay(labelStack, alignment: .bottomLeading)
      .onTapGesture(perform: increase)
      .contextMenu { contextMenuContent }
      .navigationLink(editScreen, $showEditingScreen)
      .alert(isPresented: $showDeletingAlert) { .deleteAlert(action: delete) }
  }
  
  @ViewBuilder
  var contextMenuContent: some View {
    Label("Unpin", systemImage: "pin").onTap(perform: unpin)
    Label("Decrease", systemImage: "minus.circle").onTap(perform: decrease).displayIf(model.count > 0)
    Label("Edit", systemImage: "pencil").onTap(perform: goToEditScreen)
    Label("Archive", systemImage: "archivebox").onTap(perform: archive)
    
    Button(role: .destructive) {
      showDeletingAlert = true
    } label: {
      Label("Delete", systemImage: "trash").onTap {}
    }
  }
  
  var chevronIcon: some View {
    Image(systemName: "chevron.right")
    .foregroundColor(WindColor.gray.c400)
    .padding(.s3)
    .displayIf(viewStore.state.isEditingMode)
  }
  
  var labelStack: some View {
    DefaultVStack {
      Text(model.count.string)
        .fontWeight(.bold)
        .font(.system(.title2, design: .rounded))
      Text(model.name)
        .fontWeight(.bold)
        .font(.system(.caption, design: .rounded))
        .lineLimit(2)
    }
    .foregroundColor(.isDarkMode ? .white : WindColor.zinc.c700)
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
    VerticalLinearGradient(colors: [
      .isDarkMode ? WindColor.zinc.c600 : WindColor.zinc.c100,
      .isDarkMode ? WindColor.zinc.c700 : WindColor.zinc.c200
    ])
  }
  
  func delete() {
    viewStore.send(.deleteBehaviour(id: model.id))
  }
  
  func goToEditScreen() {
    showEditingScreen = true
  }
  
  func archive() {
    viewStore.send(.updateArchive(id: model.id, archive: true))
  }
  
  func unpin() {
    viewStore.send(.updatePinned(id: model.id, pinned: false))
  }
  
  func decrease() {
    vibrate()
    viewStore.send(.deleteEntry(behaviour: model.id))
  }
  
  func increase() {
    vibrate()
    viewStore.send(.addEntry(behaviour: model.id))
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
