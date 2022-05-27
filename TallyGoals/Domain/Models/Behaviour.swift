import SwiftUI
import CoreData

struct Behaviour: Equatable, Identifiable {
    let id: NSManagedObjectID
    var emoji: String
    var name: String
    var pinned: Bool = false
    var archived: Bool = false
    var favorite: Bool = false
}
