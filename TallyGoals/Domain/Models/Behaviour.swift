import SwiftUI
import SwiftWind
import CoreData

struct Behaviour: Equatable, Identifiable {
  let id: NSManagedObjectID
  var emoji: String
  var name: String
  var pinned: Bool = false
  var archived: Bool = false
  var favorite: Bool = false
  var colorId: Int
  var count: Int
  
  var color: WindColor {
    let color = WindColors.init(rawValue: colorId) ?? .gray
    return color.color
  }
}

extension Behaviour {
  var title: String {
    emoji + " " + name
  }
}
