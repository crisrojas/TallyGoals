import SwiftUI

extension View {
  func navigationify() -> some View {
    NavigationView {
      self
    }
  }
}

extension Int {
  var string: String {
    "\(self)"
  }
}

extension Int: Identifiable {
  public var id: Self {
    self
  }
}

extension View {
  func x(_ value: CGFloat) -> some View {
    self.offset(x: value)
  }
  
  func y(_ value: CGFloat) -> some View {
    self.offset(y: value)
  }
  
  func bindHeight(to value: Binding<CGFloat>) -> some View {
    self
      .modifier(BindingSizeModifier(value: value, dimension: .height))
    
  }
  
  func bindWidth(to value: Binding<CGFloat>) -> some View {
    self
      .modifier(BindingSizeModifier(value: value, dimension: .width))
  }
}

struct BindingSizeModifier: ViewModifier {
  
  @Binding var value: CGFloat
  
  let dimension: Dimension
  
  enum Dimension {
    case width
    case height
  }
  
  func body(content: Content) -> some View {
    GeometryReader { geo in
      content
        .onAppear {
          switch dimension {
          case .width:
            value = geo.size.width
          case .height:
            value = geo.size.width
          }
        }
    }
  }
}


extension Array {
  var isNotEmpty: Bool {
    !self.isEmpty
  }
}


extension Color {
  static var defaultBackground: Self {
    Color(UIColor.secondarySystemBackground)
  }
}


extension NotificationCenter {
  static func collapseRowList() {
    NotificationCenter.default.post(
      name: .didTapListParentScreen,
      object: nil
    )
  }
  static let collapseRowNotification = NotificationCenter.default
    .publisher(for: .didTapListParentScreen)
}

extension Notification.Name {
  static let didTapListParentScreen = Notification.Name(.didTapListParentScreen)
}

extension String {
  static let didTapListParentScreen = "didTapListParentScreen"
}
