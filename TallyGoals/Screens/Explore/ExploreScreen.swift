//
//  ExploreScreen.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 13/06/2022.
//

import SwiftUI
import SwiftUItilities
import SwiftWind


extension Text {
  
  func roundedFont(_ style: Font.TextStyle) -> Text {
    self.font(.system(style, design: .rounded))
  }
}

extension View {
  func roundedFont(_ style: Font.TextStyle) -> some View {
    self.font(.system(style, design: .rounded))
  }
}

struct BindingPressStyle: ButtonStyle {
  
  @Binding var isPressed: Bool
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .onChange(of: configuration.isPressed) { newValue in
        isPressed = newValue
      }
  }
}



struct PresetCardBis: View {
  
  @State var width: CGFloat = .zero
  @State var isPressing = false
  
  private var height: CGFloat {
    width * 420/340
  }
  
  let emoji: String
  let items: Array<Preset>.SubSequence
  
  var body: some View {
    
   Color.clear
      .maxWidth(.infinity)
      .bindWidth(to: $width)
      .height(height)
      .horizontal(.horizontal)
    .background(
      Image("spirituality")
      .resizable()
      .width(width)
      .height(height)
      .aspectRatio(contentMode: .fit)
      .cornerRadius(.s4)
      .shadow(
        color: .black.opacity(0.15),
        radius: 8,
        x: 0,
        y: 0
      )
    i
    )
    .overlay(
        VStack(alignment: .leading) {
              Text("Bien démarrer".uppercased())
                .font(.subheadline)
                .fontWeight(.bold)
              .foregroundColor(WindColor.neutral.c600)
              Text("Décodez le codage")
                    .font(.title2)
                .fontWeight(.bold)
          .foregroundColor(WindColor.neutral.c700)
              Text(emoji)
              Spacer()
          
        }
        .padding()
        .alignX(.leading)
        .width(width)
    )
    .scaleEffect(isPressing ? 0.96 : 1)
    .animation(.easeIn(duration: 0.2), value: isPressing)
    .onTap { print("Hello") }
    .buttonStyle(BindingPressStyle(isPressed: $isPressing))
  }
  
  var background: some View {
    VerticalLinearGradient(colors: [WindColor.teal.c500, WindColor.teal.c700])
    .mask( Image("spirituality") .resizable()
            .aspectRatio(contentMode: .fill))
//    .overlay(.thinMaterial)
  }
}


struct ExploreDetailModel {}
final class ExploreManager: ObservableObject {
  @Published var detailModel: ExploreDetailModel?
}


struct ExploreScreen: View {
  @State var showDetail = false
  @GestureState var isPressed = false
  
  @Namespace var namespace
  let viewStore: AppViewStore
  
  let model = presets.chunked(on: \.emoji)
  
  var body: some View {
      DefaultVStack {
        
        ForEach(model, id: \.0) { emoji, items in
//          let item = model[index]
//          Text(emoji)
//          ForEach(items) { item in
//            Text(item.name)
//          }
          PresetCardBis(
            emoji: emoji,
            items: items
          )
         
          .top(.s6)
        }
        
       
        
//        PresetCard()
//        PresetCard()
//        PresetCard()
//        PresetCard()
//        PresetCard()
//          .scaleEffect(isPressed ?  0.95 : 1)
//          .animation(.spring(), value: isPressed)
//          .gesture (
////            scrollDisabled.toggle()
//            DragGesture(minimumDistance: 0)
//              .updating($isPressed) { currentState, gestureState, _ in
//                gestureState = true
//              }
//              .onEnded { _ in
//                showDetail.toggle()
//                viewStore.send(.toggleTabbar)
//              }
//          )
//
//        PresetCard(containerScrollable: $scrollDisabled, namespace: namespace)
//        PresetCard(containerScrollable: $scrollDisabled, namespace: namespace)
//        PresetCard(containerScrollable: $scrollDisabled, namespace: namespace)
//        PresetCard(containerScrollable: $scrollDisabled, namespace: namespace)
      }
      .bottom(.s6)
      .scrollify()
    .overlay(
    
      VStack {
        Text("Hello world")
      }
      .background(WindColor.gray.c400.fullScreen())
      .displayIf(false)
    )
    .overlay(
      Color.clear
      .background(.thinMaterial)
      .height(.statusBarHeight).ignoresSafeArea(),
      alignment: .top
    )

//      if showDetail {
//      PresetDetailView(namespace: namespace)
//        .frame(maxWidth: .infinity)
//        .frame(maxHeight: .infinity)
//      .background(Color.white)
//      .zIndex(1)
//        .onTapGesture {
//          showDetail.toggle()
//          viewStore.send(.toggleTabbar)
//        }
//
//      }
//    .animation(.spring(), value: showDetail)
  }
}

struct PresetCard: View {
  @Namespace var namespace
  @State var isCollapsed = true
  
  var body: some View {
    ZStack {
      if isCollapsed {
        card
        
      } else {
        PresetDetailView(namespace: namespace)
//          .onTapGesture {
//            isCollapsed.toggle()
//          }
      }
    }
    .animation(.spring(), value: isCollapsed)
    .onTapGesture {
      isCollapsed.toggle()
    }

  }
  
  var card: some View {
          WindColor.gray.c200
            .height(240)
            .matchedGeometryEffect(id: "rectangle", in: namespace)
            .overlay(
              Image("spirituality")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .matchedGeometryEffect(id: "image", in: namespace)
            )
            .overlay(
              Color.black.opacity(0.4)
                .background(.thinMaterial)
                .height(.s16)
                .matchedGeometryEffect(id: "bar", in: namespace)
                .overlay(
                  Text("🙏  Spiritualité")
                   .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(.body, design: .rounded ))
                    .leading(.horizontal)
                    .matchedGeometryEffect(id: "title", in: namespace)
                  ,
                  alignment: .leading
                )
              ,
              alignment: .bottom
    
            )
            .cornerRadius(.s5)
            .shadow(
              color: .black.opacity(0.3),
              radius: 20,
              x: 0,
              y: 10
            )
          .top(.s4)
            .horizontal(.horizontal)
  }
}


struct PresetDetailView: View {
  
  @State var appear = false
  let namespace: Namespace.ID
  
  var body: some View {
    VStack {
   
      WindColor.gray.c200
        .height(500)
        .matchedGeometryEffect(id: "rectangle", in: namespace)
        .overlay(
          Image("spirituality")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .matchedGeometryEffect(id: "image", in: namespace)
        )
        .overlay(
          Color.black.opacity(0.4)
            .background(.thinMaterial)
            .height(.s16)
            .matchedGeometryEffect(id: "bar", in: namespace)
            .overlay(
              Text("🙏  Spiritualité")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.system(.body, design: .rounded ))
                .leading(.horizontal)
                .matchedGeometryEffect(id: "title", in: namespace)
              ,
              alignment: .leading
            )
          ,
          alignment: .bottom

        )
    
      Spacer()
    }
    .scrollify()
    .fullScreen()
  }
}


import SwiftUI
import SwiftWind

extension WindColor: Equatable {
  
  
  public static func == (lhs: WindColor, rhs: WindColor) -> Bool {
    lhs.c50 == rhs.c50
  }
}

struct DetailModel: Equatable {
  
  let emoji: String
  let color: WindColor
}


final class Manager: ObservableObject {
  @Published var selectedIndex: Int?
  @Published var detailModel: DetailModel?
  
  @Published var namespace: Namespace.ID?
  
  func toggle(index: Int) {
    guard
    let selectedIndex = selectedIndex,
    selectedIndex == index
    else {
      selectedIndex = index
      return
    }
    
    self.selectedIndex = nil
  }
}

struct StackCardComponent: View {
  
  @StateObject var manager = Manager()
  
  
 var model: [DetailModel] = [
    DetailModel(emoji: "👍", color: WindColor.blue),
    DetailModel(emoji: "🐛", color: WindColor.lime),
    DetailModel(emoji: "🍻", color: WindColor.amber),
    DetailModel(emoji: "⌛️", color: WindColor.rose),
  ]
  
  
  
    var body: some View {
      
      ScrollView {
        VStack(alignment: .leading, spacing: 0) {
          
          ForEach(model.indices) { index in
            CardRow(
              index: index,
              model: model[index]
            )
            .environmentObject(manager)
          }
          
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .frame(alignment: .leading)
        .padding(.top, 24)
        
      }
      .animation(.spring(), value: manager.detailModel)
      .overlay(detailView)
    }
  
  @State var appear: Bool = false
 
  @ViewBuilder
  var detailView: some View {
    if let detailModel = manager.detailModel, let namespace =  manager.namespace {
        VStack {
          ScrollView(showsIndicators: false) {
            HStack {
              VStack(alignment: .leading, spacing: 12) {
              
                ForEach(Array(0...24).indices) { index in
                  Text("Behaviour \(index)")
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(detailModel.color.c600)
                }
                .onAppear {
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    appear = true
                  }
                }
                .onDisappear {
                  appear = false
                }
              }
              Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 80)
            .padding(.bottom, 24)
          }
          
          .frame(maxWidth: .infinity)
          .frame(maxHeight: .infinity)
          .overlay(
            HStack {
            Text(detailModel.emoji)
                .matchedGeometryEffect(id: "emoji", in: namespace)
              
              Spacer()
              Image(systemName: "arrow.up.left.and.arrow.down.right")
                .foregroundColor(detailModel.color.c600)
                .matchedGeometryEffect(id: "expand.collapse", in: namespace)
                .onTapGesture {
                  appear = false
                  withAnimation(.spring()) {
                    manager.detailModel = nil
                  }
                }
              
            }
            .padding()
//            .background(
//              detailModel.color.c200.cornerRadius(16).opacity(appear ? 0.8 : 0)
//            )
            ,
            
            alignment: .top
          
          )
          .background(
            detailModel.color.c200
              .cornerRadius(16)
              .shadow(
                color: .black.opacity(0.1),
                radius: 10,
                x: 0,
                y: 0
              )
              .matchedGeometryEffect(id: "color", in: namespace)
          )
          
          .padding(12)
        }
        .animation(.easeInOut, value: appear)
        .background(Color.black.opacity(0.3))
        .background(
          .ultraThinMaterial
        )
        
      } else {
        EmptyView()
      }
  }
}


struct CardRow: View {
  
  @EnvironmentObject var manager: Manager
 
  @Namespace var namespace
  let index: Int
  let model: DetailModel
  
  private var offset: CGFloat {
//    guard let selectedIndex = manager.selectedIndex else {
      if index == 0 {
        return 0
      } else {
        return Double(index) * -140
      }
//    }
    
//    if selectedIndex != index {
//      return 0
//    } else {
//      return Double(index) * -140
//    }
  }
  
  private var isSelected: Bool {
    manager.selectedIndex == index
  }
  
  private var offsetToAdd: CGFloat {
    
    guard let selectedIndex = manager.selectedIndex else {
      return 0
    }
    
    if selectedIndex == index {
      return 0
    } else {
      
      if selectedIndex < index {
        return 110
      } else {
        return 0
      }
    }
    
  }
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        HStack {
          Text(model.emoji)
            .matchedGeometryEffect(id: "emoji", in: namespace)
          Spacer()
          if isSelected {
            Image(systemName: "arrow.up.left.and.arrow.down.right")
              .matchedGeometryEffect(id: "expand.collapse", in: namespace)
              .foregroundColor(model.color.c500)
              .onTapGesture {
                
                withAnimation(.spring()) {
                  manager.detailModel = model
                }
              }
          }
        }
        
          list
          .opacity(isSelected ? 1 : 0)
          .padding(.top, 16)
          .padding(.bottom, 32)
        
        Spacer()
      }
      
      Spacer()
      
    
    }
    .padding()
    .frame(maxWidth: .infinity)
    .frame(alignment: .leading)
    .background(model.color.c200.cornerRadius(16).matchedGeometryEffect(id: "color", in: namespace))
   
    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -10)
    .offset(y: offset + offsetToAdd)
    .animation(.spring(), value: offsetToAdd)
    .animation(.spring(), value: isSelected)
    .onTapGesture {
      manager.namespace = namespace
      manager.toggle(index: index)
    }
  }
  
  @ViewBuilder
  var list: some View {
    VStack(spacing: 12) {
      HStack {
  //      Text(emoji)
        Text("Behaviour 1")
          .font(.system(.body, design: .rounded))
          .fontWeight(.medium)
      }
      
      HStack {
  //      Text(emoji)
        Text("Behaviour 2")
          .font(.system(.body, design: .rounded))
          .fontWeight(.medium)
      }
      
      HStack {
  //      Text(emoji)
        Text("Behaviour 3")
          .font(.system(.body, design: .rounded))
          .fontWeight(.medium)
      }
    }
    
    .foregroundColor(model.color.c600)
  }
}


extension View {
    // https://www.hackingwithswift.com/forums/swiftui/a-guide-to-delaying-gestures-in-scrollview/6005
    func delaysTouches(for duration: TimeInterval = 0.25, onTap action: @escaping () -> Void = {}) -> some View {
        modifier(DelaysTouches(duration: duration, action: action))
    }
}

fileprivate struct DelaysTouches: ViewModifier {
    @State private var disabled = false
    @State private var touchDownDate: Date? = nil

    var duration: TimeInterval
    var action: () -> Void

    func body(content: Content) -> some View {
        Button(action: action) {
            content
        }
        .buttonStyle(DelaysTouchesButtonStyle(disabled: $disabled, duration: duration, touchDownDate: $touchDownDate))
        .disabled(disabled)
    }
}

fileprivate struct DelaysTouchesButtonStyle: ButtonStyle {
    @Binding var disabled: Bool
    var duration: TimeInterval
    @Binding var touchDownDate: Date?

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed, perform: handleIsPressed)
    }

    private func handleIsPressed(isPressed: Bool) {
        if isPressed {
            let date = Date()
            touchDownDate = date

            DispatchQueue.main.asyncAfter(deadline: .now() + max(duration, 0)) {
                if date == touchDownDate {
                    disabled = true

                    DispatchQueue.main.async {
                        disabled = false
                    }
                }
            }
        } else {
            touchDownDate = nil
            disabled = false
        }
    }
}
