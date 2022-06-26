import Combine
import ComposableArchitecture
import CoreData
import AVFAudio

final class BehaviourRepository {
  
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func fetchBehaviours() -> Effect<[Behaviour], Error> {
    Deferred { [context] in
      Future<[Behaviour], Error> { [context] promise in
        
//        context.perform {
          do {

            let request: NSFetchRequest<BehaviourEntity> = BehaviourEntity.fetchRequest()
            let result: [BehaviourEntity] = try context.fetch(request)

            let behaviours: [Behaviour?] = result.map { entity in
              guard
                let emoji = entity.emoji,
                let name = entity.name,
                let id = entity.id
              else {
                return nil
              }

              return Behaviour(
                id: id,
                emoji: emoji,
                name: name,
                pinned: entity.pinned,
                archived: entity.archived,
                favorite: entity.favorite,
                count: entity.entries?.count ?? 0
              )
            }

            promise(.success(behaviours.compactMap { $0 }))

          } catch {
            promise(.failure(error))
          }
      }
      
    }
    .eraseToEffect()
  }
  
  private func mapBehaviorsEntities(_ entities: [BehaviourEntity]) throws -> [Behaviour] {
    
    let behaviours: [Behaviour] = try entities.map { entity in
      guard
        let emoji = entity.emoji,
        let name = entity.name,
        let id = entity.id
      else {
        throw CustomError.fetchError
      }

      return Behaviour(
        id: id,
        emoji: emoji,
        name: name,
        pinned: entity.pinned,
        archived: entity.archived,
        favorite: entity.favorite,
        count: entity.entries?.count ?? 0
      )
    }
    
    return behaviours
  }
  
  func createBehaviour(id: UUID, emoji: String, name: String) -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          do {
            let entity = BehaviourEntity(context: context)
            entity.id = id
            entity.emoji = emoji
            entity.name = name
            entity.favorite = false
            entity.archived = false
            entity.pinned = false
            
            try context.save()
            promise(.success(()))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
    .eraseToEffect()
  }
  
  func deleteBehaviour(id: UUID) -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          do {
            let idPredicate = NSPredicate(format: "id == %@", id as CVarArg)
            let behaviourRequest: NSFetchRequest<BehaviourEntity>
            
            behaviourRequest = BehaviourEntity.fetchRequest()
            behaviourRequest.predicate = idPredicate
            
            // @todo safe unwrap
            let object = try context.fetch(behaviourRequest).first!
            context.delete(object)
            promise(.success(()))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
    .eraseToEffect()
  }
  
  func updateBehaviour
  (id: UUID, emoji: String, name: String)
  -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          do {
//            let object = try context.existingObject(with: id)
            let idPredicate = NSPredicate(format: "id == %@", id as CVarArg)
//            let behaviour = try context.existingObject(with: behaviourId) as? BehaviourEntity
            let behaviourRequest: NSFetchRequest<BehaviourEntity>
            
            behaviourRequest = BehaviourEntity.fetchRequest()
            behaviourRequest.predicate = idPredicate
            
            // @todo safe unwrap
            let object = try context.fetch(behaviourRequest).first!
            object.setValue(emoji, forKey: "emoji")
            object.setValue(name, forKey: "name")
            try context.save()
            promise(.success(()))
          } catch {
            promise(.failure(error))
            print(error.localizedDescription)
          }
        }
      }
    }
    .eraseToEffect()
  }
  
  func updateArchived
  (id: UUID, archived: Bool) -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          do {
//            let object = try context.existingObject(with: id)
            let idPredicate = NSPredicate(format: "id == %@", id as CVarArg)
//            let behaviour = try context.existingObject(with: behaviourId) as? BehaviourEntity
            let behaviourRequest: NSFetchRequest<BehaviourEntity>
            
            behaviourRequest = BehaviourEntity.fetchRequest()
            behaviourRequest.predicate = idPredicate
            
            // @todo safe unwrap
            let object = try context.fetch(behaviourRequest).first!
            object.setValue(archived, forKey: "archived")
            object.setValue(false, forKey: "favorite")
            object.setValue(false, forKey: "pinned")
            try context.save()
            promise(.success(()))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
    .eraseToEffect()
  }
  
  func updateFavorite
  (id: UUID, favorite: Bool) -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          do {
//            let object = try context.existingObject(with: id)
            
            let idPredicate = NSPredicate(format: "id == %@", id as CVarArg)
//            let behaviour = try context.existingObject(with: behaviourId) as? BehaviourEntity
            let behaviourRequest: NSFetchRequest<BehaviourEntity>
            
            behaviourRequest = BehaviourEntity.fetchRequest()
            behaviourRequest.predicate = idPredicate
            
            // @todo safe unwrap
            let object = try context.fetch(behaviourRequest).first!
           
            
            object.setValue(favorite, forKey: "favorite")
            try context.save()
            promise(.success(()))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
    .eraseToEffect()
  }
  
  func updatePinned
  (id: UUID, pinned: Bool) -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          do {
//            let object = try context.existingObject(with: id)
            let idPredicate = NSPredicate(format: "id == %@", id as CVarArg)
//            let behaviour = try context.existingObject(with: behaviourId) as? BehaviourEntity
            let behaviourRequest: NSFetchRequest<BehaviourEntity>
            
            behaviourRequest = BehaviourEntity.fetchRequest()
            behaviourRequest.predicate = idPredicate
            
            // @todo safe unwrap
            let object = try context.fetch(behaviourRequest).first!
            object.setValue(pinned, forKey: "pinned")
            try context.save()
            promise(.success(()))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
    .eraseToEffect()
  }
  
  // @todo: The method doesn't work the first time usded
  func createEntity(for behaviourId: UUID) -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          do {
            
//            let behaviour = try context.existingObject(with: behaviourId) as? BehaviourEntity
            
            let idPredicate = NSPredicate(format: "id == %@", behaviourId as CVarArg)
//            let behaviour = try context.existingObject(with: behaviourId) as? BehaviourEntity
            let behaviourRequest: NSFetchRequest<BehaviourEntity>
            
            behaviourRequest = BehaviourEntity.fetchRequest()
            behaviourRequest.predicate = idPredicate
            
            // @todo safe unwrap
            let behaviour = try context.fetch(behaviourRequest).first!
            
//            guard let behaviour = behaviour else {
//              // @todo throw error
//              print("Error while trying to retrieve behaviour")
//              return
//            }
//
            let entry = EntryEntity(context: context)
            entry.date = Date()
            behaviour.addToEntries(entry)
            try context.save()
            
            promise(.success(()))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
    .eraseToEffect()
  }
  
  func deleteLastEntry(for behaviourId: UUID) -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          
          do {
            let idPredicate = NSPredicate(format: "id == %@", behaviourId as CVarArg)
//            let behaviour = try context.existingObject(with: behaviourId) as? BehaviourEntity
            let behaviourRequest: NSFetchRequest<BehaviourEntity>
            
            behaviourRequest = BehaviourEntity.fetchRequest()
            behaviourRequest.predicate = idPredicate
            
            guard let behaviour = try context.fetch(behaviourRequest).first else {
              // @todo throw error
              return
            }
           
            
            let fetchRequest: NSFetchRequest<EntryEntity>
            fetchRequest = EntryEntity.fetchRequest()
            let allEntries = try context.fetch(fetchRequest)
            
            let behaviourEntries = allEntries.filter { entry in
              entry.behaviour == behaviour
            }
            
            if let last = behaviourEntries.last {
              context.delete(last)
            }
            
            
            try context.save()
            
            promise(.success(()))
          } catch {
            promise(.failure(error))
          }
          
        }
      }
    }
    .eraseToEffect()
  }
}


enum CustomError: Error {
  case fetchError
  case unexistentSelf
}
