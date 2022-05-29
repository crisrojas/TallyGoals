import Combine
import ComposableArchitecture
import CoreData
import AVFAudio

final class BehaviourRepository {
  
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func loadAll() -> Effect<[Behaviour], Error> {
    Deferred { [context] in
      Future<[Behaviour], Error> { [context] promise in
        
        do {
          
          let request: NSFetchRequest<BehaviourEntity> = BehaviourEntity.fetchRequest()
          
          let result: [BehaviourEntity] = try context.fetch(request)
          
          let behaviours = result.map { entity in
            Behaviour(
              id: entity.objectID,
              emoji: entity.emoji!,
              name: entity.name!,
              pinned: entity.pinned,
              archived: entity.archived,
              favorite: entity.favorite,
              colorId: Int(entity.color),
              count: entity.entries?.count ?? 0
            )
          }
          
          promise(.success(behaviours))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .eraseToEffect()
  }
  
  func readBehaviours() -> Effect<[Behaviour], Error> {
    Effect<[Behaviour], Error>.future { [context] (result: @escaping (Result<[Behaviour], Error>) -> Void) -> Void in
      context.performAndWait { () -> Void in
        result(
          Result<[Behaviour], Error> {
            
            let request: NSFetchRequest<BehaviourEntity> = BehaviourEntity.fetchRequest()
            
            let result: [BehaviourEntity] = try context.fetch(request)
            
            let behaviours = result.map { entity in
              Behaviour(
                id: entity.objectID,
                emoji: entity.emoji ?? "error",
                name: entity.name ?? "error",
                pinned: entity.pinned,
                archived: entity.archived,
                favorite: entity.favorite,
                colorId: Int(entity.color),
                count: entity.entries?.count ?? 0
              )
            }
            return behaviours
          }
        )
      }
    }
  }
  
  func createBehaviour(emoji: String, name: String) -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          do {
            let entity = BehaviourEntity(context: context)
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
  
  func deleteBehaviour(id: NSManagedObjectID) -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          do {
            let object = try context.existingObject(with: id)
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
  (id: NSManagedObjectID, emoji: String, name: String)
  -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          do {
            let object = try context.existingObject(with: id)
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
  (id: NSManagedObjectID, archived: Bool) -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          do {
            let object = try context.existingObject(with: id)
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
  (id: NSManagedObjectID, favorite: Bool) -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          do {
            let object = try context.existingObject(with: id)
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
  (id: NSManagedObjectID, pinned: Bool) -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          do {
            let object = try context.existingObject(with: id)
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
  func createEntity(for behaviourId: NSManagedObjectID) -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          do {
            
            let behaviour = try context.existingObject(with: behaviourId) as? BehaviourEntity
            
            guard let behaviour = behaviour else {
              // @todo throw error
              print("Error while trying to retrieve behaviour")
              return
            }
            
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
  
  func deleteLastEntry(for behaviourId: NSManagedObjectID) -> Effect<Void, Error> {
    Deferred { [context] in
      Future<Void, Error> { [context] promise in
        context.perform {
          
          do {
            
            let behaviour = try context.existingObject(with: behaviourId) as? BehaviourEntity
            
            guard let behaviour = behaviour else {
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
