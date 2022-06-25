import SwiftUI
import SwiftWind
import CoreData

struct Behaviour: Equatable, Identifiable {
  let id: UUID
  var emoji: String
  var name: String
  var pinned: Bool = false
  var archived: Bool = false
  var favorite: Bool = false
  var count: Int
}
