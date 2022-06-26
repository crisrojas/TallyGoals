import SwiftUI

extension Text {
  
  @ViewBuilder
  static func unwrap(_ optional: String?) -> some View {
    if let safeValue = optional {
      Text(safeValue)
    } else {
      EmptyView()
    }
  }
}

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


extension String: Identifiable {
  public var id: String { self }
}

extension View {
  
  // MARK: - Move to swiftuitilities
  func navigationify() -> some View {
    NavigationView {
      self
    }
  }
  
  func x(_ value: CGFloat) -> some View {
    self.offset(x: value)
  }
  
  func y(_ value: CGFloat) -> some View {
    self.offset(y: value)
  }
  
  func xy(_ value: CGFloat) -> some View {
    self
    .x(value)
    .y(value)
  }
  
  func bindHeight(to value: Binding<CGFloat>) -> some View {
    self
      .modifier(BindingSizeModifier(value: value, dimension: .height))
    
  }
  
  func bindWidth(to value: Binding<CGFloat>) -> some View {
    self
      .modifier(BindingSizeModifier(value: value, dimension: .width))
  }
  
  
  func highPriorityTapGesture(perform action: @escaping () -> Void) -> some View {
    self.highPriorityGesture(
      TapGesture()
        .onEnded(action)
    )
  }
  
  func simultaneusLongGesture(perform action: @escaping () -> Void, animated: Bool = true) -> some View {
    self.simultaneousGesture(
      LongPressGesture()
        .onEnded { _ in
          if animated {
            withAnimation { action() }
          } else {
            action()
          }
        }
    )
  }
  
  @ViewBuilder
  func highPriorityTapGesture(if condition: Bool, action: @escaping () -> Void) -> some View {
    if condition {
      self.highPriorityTapGesture(perform: action)
    } else {
      self
    }
  }
  
  @ViewBuilder
  func highPriorityGesture<T>(if condition: Bool, _ gesture: T, including mask: GestureMask = .all) -> some View where T : Gesture {
    if condition {
      self.highPriorityGesture(gesture)
    } else {
      self
    }
  }
}

extension View {
  func vibrate(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType = .success) {
    UIImpactFeedbackGenerator.shared.impactOccurred()
  }
}

extension ViewModifier {
  func vibrate(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType = .success) {
    UIImpactFeedbackGenerator.shared.impactOccurred()
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
    content.background(
    GeometryReader { geo in
     Color.clear
        .onAppear {
          switch dimension {
          case .width:
            value = geo.size.width
          case .height:
            value = geo.size.width
          }
        }
    }
    )
  }
}

extension Int {
  var string: String {
    "\(self)"
  }
  
  var cgFloat: CGFloat {
    CGFloat(self)
  }
}

extension Int: Identifiable {
  public var id: Self {
    self
  }
}

extension Array {
  var isNotEmpty: Bool {
    !self.isEmpty
  }
}

extension Array {
  var count: CGFloat {
    self.count.cgFloat
  }
}

extension Array {
  func getOrNil(index: Int) -> Element? {
    guard self.indices.contains(index) else { return nil }
    return self[index]
  }
}

extension NotificationCenter {
  // @todo: delete?
  static func collapseRowList() {
    NotificationCenter.default.post(
      name: .didTapListParentScreen,
      object: nil
    )
  }
  
  // @todo: delete?
  static let collapseRowNotification = NotificationCenter.default
    .publisher(for: .didTapListParentScreen)
}

extension Notification.Name {
  static let didTapListParentScreen = Notification.Name(.didTapListParentScreen)
}

extension String {
  static let didTapListParentScreen = "didTapListParentScreen"
}

extension UIBarButtonItem {
  static func hideBackButtonLabel() {
    Self.appearance(
      whenContainedInInstancesOf:
        [UINavigationBar.classForCoder() as! UIAppearanceContainer.Type])
      .setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal
      )
  }
}

extension Bool {
  static var isDarkMode: Bool {
    UITraitCollection.current.userInterfaceStyle == .dark
  }
}

typealias NotificationFeedback = UINotificationFeedbackGenerator
extension NotificationFeedback {
  static let shared = UINotificationFeedbackGenerator()
}
