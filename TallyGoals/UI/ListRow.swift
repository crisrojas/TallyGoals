import CoreData
import ComposableArchitecture
import SwiftUI
import SwiftUItilities
import SwiftWind

struct SwipeActionView: View {
    
    let tintColor: Color
    let backColor: Color
    let systemSymbol: String
    
    @Binding var offset: CGFloat
    let action: () -> ()
    
    var body: some View {
        backColor
            .width(40)
            .buttonStyle(.plain)
            .onTap {
                withAnimation {
                    offset = .zero
                    action()
                }
            }
            .overlay(
                Image(systemName: systemSymbol)
                    .foregroundColor(tintColor)
            )
    }
}

struct NewRow: View {
    
    let model: Behaviour
    let color: WindColor
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                
                Text("0")
                    .font(.title)
                    .fontWeight(.black)
                
                Text(model.emoji + " " + model.name)
                    .font(.caption)
                
                Spacer()
                
                Rectangle()
                    .foregroundColor(color.c800)
                    .size(36)
                    .overlay(Text("-"))
                    .cornerRadius(5)
                //.trailing(12)
                
                Rectangle()
                    .foregroundColor(color.c800)
                    .size(36)
                    .overlay(Text("+"))
                    .cornerRadius(5)
            }
            .horizontal(24)
            .vertical(12)
            
            Rectangle()
                .foregroundColor(color.c700)
                .height(1)
        }
        
        .background(color.c900)
    }
}
struct Row: View {
    
    @State var offset: CGFloat = .zero
    @State var showEditScreen = false
    @State var isEditing = false
    
    let model: Behaviour
    let store: AppStore
    
    var body: some View {
        WithViewStore(store) { viewStore in
            DefaultVStack {
                HStack {
                    Text(model.emoji)
                    Text(model.name)
                    Spacer()
                    Text(getCount(
                        behaviourId:model.id, 
                        viewStore:viewStore
                    ))
                }
                .padding(10)
                .background(Color(UIColor.systemBackground))
                .offset(x: offset)
                .simultaneousGesture(
                    LongPressGesture()
                        .onEnded { _ in
                            //showEditScreen = true
                            withAnimation {
                                isEditing.toggle()
                            }
                        }
                )
                .highPriorityGesture(
                    TapGesture()
                        .onEnded {
                            withAnimation {
                                
                                NotificationCenter.collapseRowList()
                                guard offset == 0 else {
                                    return
                                }
                                guard !isEditing else {
                                    isEditing = false
                                    return
                                }
                                viewStore.send(.addEntry(behaviour: model.id))
                            }
                        }
                )
                .background(
                    DefaultHStack {
                        
                        
                        SwipeActionView(
                            tintColor: .yellow50,
                            backColor: .yellow500,
                            systemSymbol: "pin",
                            offset: $offset
                        ) { 
                            viewStore.send(
                                .updatePinned(id: model.id, pinned: true)
                            )
                        }
                        
                        Spacer()
                        
                        SwipeActionView(
                            tintColor: .orange50,
                            backColor: .orange500,
                            systemSymbol: "archivebox",
                            offset: $offset
                        ) { 
                            viewStore.send(.updateArchive(id: model.id, archive: true))
                        }
                        
                        SwipeActionView(
                            tintColor: .red50,
                            backColor: .red700,
                            systemSymbol: "trash",
                            offset: $offset
                        ) { 
                            viewStore.send(.deleteBehaviour(id: model.id))
                        }
                    }
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            
                            let width = value.translation.width
                            offset = width
                        }
                        .onEnded { value in
                            let width = value.translation.width
                            
                            if width > 1 {
                                withAnimation { offset = 40 }
                            } else if width < -80 {
                                withAnimation { offset = -80 }
                            } else if width < -40 {
                                withAnimation { offset = -40 }
                            } else {
                                withAnimation { offset = 0 }
                            }
                        }
                )
                
                if isEditing {
                
                Rectangle()
                        .cornerRadius(8)
                    .height(80)
                    .horizontal(16)
                    .bottom(16)
                    .foregroundColor(.black)
                }
                
                Divider()
            }
            .onReceive(NotificationCenter.collapseRowNotification) { _ in
                guard offset != 0 else { return }
                withAnimation { offset = 0 }
            }
            .navigationLink(
                editScreen,
                $showEditScreen
            )
        }
        
    }
    
    var editScreen: some View {
        BehaviourEditScreen(
            store: store, 
            item: model, 
            emoji: model.emoji, 
            name: model.name
        )
    }
    
    
    func getCount
    (behaviourId: NSManagedObjectID, viewStore: AppViewStore) -> String {
        viewStore
            .entries
            .filter { $0.behaviourId == behaviourId }
            .count
            .string
    }
}


struct ListRow: View {
    
    @State var showDetail = false
    let store: AppStore
    let item: Behaviour
    let archive: Bool
    
    init(
        store: AppStore,
        item: Behaviour,
        archive: Bool = false
    ) {
        self.store = store
        self.item = item
        self.archive = archive
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                
                //if !archive {
                Rectangle()
                    .width(2)
                    .foregroundColor(color)
                //Image(systemName: item.favorite ? "star.fill" : "star")
                //.resizable()
                //.size(10)
                //.foregroundColor(item.favorite ? .yellow : .gray)
                //.opacity(item.favorite ? 1 : 0.2)
                
                //}
                
                Text(item.emoji)
                    .grayscale(archive ? 1 : 0)
                Text(item.name)
                
                Spacer()
                
                let count = getCount(
                    behaviourId: item.id,
                    viewStore: viewStore
                )
                
                Text(count.string)
            }
            .background(detailLinkTwo)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12))
            .onTapGesture { 
                withAnimation {
                    if viewStore.adding {
                        viewStore.send(
                            .addEntry( behaviour: item.id)
                        )
                    } else {
                        viewStore.send(
                            .deleteEntry(behaviour: item.id)
                        )
                    }
                }
            }
            .onLongPressGesture {
                print("longpress")
                showDetail = true
            }
        }
    }
    
    
    var color: Color {
        item.pinned 
        ? .indigo : .clear
    }
    
    var testLink: some View {
        Text("link")
    }
    
    var detailLink: some View {
        EmptyNavigationLink(
            destination: editScreen, 
            isActive: $showDetail
        )
            .disabled(true)
    }
    
    var editScreen: some View {
        BehaviourEditScreen(
            store: store, 
            item: item, 
            emoji: item.emoji, 
            name: item.name
        )
    }
    
    var detailLinkTwo: some View {
        NavigationLink(destination: editScreen, isActive: $showDetail) { 
            EmptyView()
        }
        .hidden()
        .buttonStyle(PlainButtonStyle())
        .disabled(true)
    }
    
    func getCount
    (behaviourId: NSManagedObjectID, viewStore: AppViewStore) -> Int {
        viewStore
            .entries
            .filter { $0.behaviourId == behaviourId }
            .count
    }
}


