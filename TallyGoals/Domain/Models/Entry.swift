import CoreData
import Foundation

struct Entry: Equatable, Identifiable {
  let id: UUID
  let behaviourId: NSManagedObjectID
  let date: Date
}

struct Goal: Equatable, Identifiable {
  let id: NSManagedObjectID
  let behaviourId: NSManagedObjectID
  let timeStamp: Date
  let goal: Int
  let archived: Bool
}

struct Presets: Equatable, Identifiable {
  let id: NSManagedObjectID
  let emoji: String
  let name: String
}
