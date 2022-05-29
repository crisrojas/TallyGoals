import SwiftUI

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
  
  // MARK: - GEstures
  func behaviourRowSwipeActions(
    offset: Binding<CGFloat>,
    isEditing: Binding<Bool>,
    viewStore: AppViewStore,
    background: Color,
    model: Behaviour
  ) -> some View {
    self.modifier(
      BehaviorRowActionsModifier(
        offset: offset,
        isEditing: isEditing,
        background: background,
        model: model,
        viewStore: viewStore
      )
    )
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
    NotificationFeedback.shared.notificationOccurred(feedbackType)
  }
}

extension ViewModifier {
  func vibrate(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType = .success) {
    NotificationFeedback.shared.notificationOccurred(feedbackType)
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


// @todo move to windcolors
import SwiftWind

enum WindColors: Int, CaseIterable {
  case slate
  case gray
  case zinc
  case neutral
  case stone
  case red
  case orange
  case yellow
  case lime
  case green
  case emerald
  case teal
  case cyan
  case sky
  case blue
  case indigo
  case violet
  case amber
  case purple
  case fuchsia
  case pink
  case rose

  
  var color: WindColor {
    switch self {
      
    case .amber:
      return .amber
    case .purple:
      return .purple
    case .slate:
      return .slate
    case .gray:
      return .gray
    case .zinc:
      return .zinc
    case .neutral:
      return .neutral
    case .stone:
      return .stone
    case .red:
      return .red
    case .orange:
      return .orange
    case .yellow:
      return .yellow
    case .lime:
      return .lime
    case .green:
      return .green
    case .emerald:
      return .emerald
    case .teal:
      return .teal
    case .cyan:
      return .cyan
    case .sky:
      return .sky
    case .blue:
      return .blue
    case .indigo:
      return .indigo
    case .violet:
      return .violet
    case .fuchsia:
      return .fuchsia
    case .pink:
      return .pink
    case .rose:
      return .rose
    }
  }
  
  var t50: Color {
    switch self {
    case .slate:
      return .slate50
    case .gray:
      return .gray50
    case .zinc:
      return .zinc50
    case .neutral:
      return .neutral50
    case .stone:
      return .stone50
    case .red:
      return .red50
    case .orange:
      return .orange50
    case .yellow:
      return .yellow50
    case .lime:
      return .lime50
    case .green:
      return .green50
    case .emerald:
      return .emerald50
    case .teal:
      return .teal50
    case .cyan:
      return .cyan50
    case .sky:
      return .sky50
    case .blue:
      return .blue50
    case .indigo:
      return .indigo50
    case .violet:
      return .violet50
    case .amber:
      return .amber50
    case .purple:
      return .purple50
    case .fuchsia:
      return .fuchsia50
    case .pink:
      return .pink50
    case .rose:
      return .rose50
    }
  }
}
