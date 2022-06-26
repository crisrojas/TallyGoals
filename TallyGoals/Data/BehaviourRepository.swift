import Combine
import ComposableArchitecture
import CoreData
import AVFAudio

final class BehaviourRepository {
  
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func fetchBehaviours() -> Effect<[Behaviour], ErrorCase> {
    Deferred { [context] in
      Future<[Behaviour], ErrorCase> { [context] promise in
          do {

            let request: NSFetchRequest<BehaviourEntity> = BehaviourEntity.fetchRequest()
            let result: [BehaviourEntity] = try context.fetch(request)
            let behaviours = try result.mapBehaviorsEntities()
            promise(.success(behaviours))

          } catch {
            promise(.failure(.genericDbError(error.localizedDescription)))
          }
      }
    }
    .eraseToEffect()
  }
  
  func createBehaviour(id: UUID, emoji: String, name: String) -> Effect<Void, ErrorCase> {
    Deferred { [context] in
      Future<Void, ErrorCase> { [context] promise in
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
            promise(.failure(.genericDbError(error.localizedDescription)))
          }
        }
      }
    }
    .eraseToEffect()
  }
  
  func deleteBehaviour(id: UUID) -> Effect<Void, ErrorCase> {
    Deferred { [context] in
      Future<Void, ErrorCase> { [context] promise in
        context.perform {
          do {
            let idPredicate = NSPredicate(format: "id == %@", id as CVarArg)
            let behaviourRequest: NSFetchRequest<BehaviourEntity>
            
            behaviourRequest = BehaviourEntity.fetchRequest()
            behaviourRequest.predicate = idPredicate
            
            guard let object = try context.fetch(behaviourRequest).first else {
              promise(.failure(.notFoundEntity))
              return
            }
            
            context.delete(object)
            promise(.success(()))
          } catch {
            promise(.failure(.genericDbError(error.localizedDescription)))
          }
        }
      }
    }
    .eraseToEffect()
  }
  
  func updateBehaviour
  (id: UUID, emoji: String, name: String)
  -> Effect<Void, ErrorCase> {
    Deferred { [context] in
      Future<Void, ErrorCase> { [context] promise in
        context.perform {
          do {
            
            let idPredicate = NSPredicate(format: "id == %@", id as CVarArg)
            let behaviourRequest: NSFetchRequest<BehaviourEntity>
            
            behaviourRequest = BehaviourEntity.fetchRequest()
            behaviourRequest.predicate = idPredicate
            
            guard let object = try context.fetch(behaviourRequest).first else {
              promise(.failure(.notFoundEntity))
              return
            }
            
            object.setValue(emoji, forKey: "emoji")
            object.setValue(name, forKey: "name")
            try context.save()
            
            promise(.success(()))
            
          } catch {
            promise(.failure(.genericDbError(error.localizedDescription)))
          }
        }
      }
    }
    .eraseToEffect()
  }
  
  func updateArchived
  (id: UUID, archived: Bool) -> Effect<Void, ErrorCase> {
    Deferred { [context] in
      Future<Void, ErrorCase> { [context] promise in
        context.perform {
          do {
            let idPredicate = NSPredicate(format: "id == %@", id as CVarArg)
            let behaviourRequest: NSFetchRequest<BehaviourEntity>
            
            behaviourRequest = BehaviourEntity.fetchRequest()
            behaviourRequest.predicate = idPredicate
            
            guard let object = try context.fetch(behaviourRequest).first else {
              promise(.failure(.notFoundEntity))
              return
            }
            object.setValue(archived, forKey: "archived")
            object.setValue(false, forKey: "favorite")
            object.setValue(false, forKey: "pinned")
            try context.save()
            promise(.success(()))
          } catch {
            promise(.failure(.genericDbError(error.localizedDescription)))
          }
        }
      }
    }
    .eraseToEffect()
  }
  
  func updateFavorite
  (id: UUID, favorite: Bool) -> Effect<Void, ErrorCase> {
    Deferred { [context] in
      Future<Void, ErrorCase> { [context] promise in
        context.perform {
          do {
            
            let idPredicate = NSPredicate(format: "id == %@", id as CVarArg)
            let behaviourRequest: NSFetchRequest<BehaviourEntity>
            
            behaviourRequest = BehaviourEntity.fetchRequest()
            behaviourRequest.predicate = idPredicate
            
            guard let object = try context.fetch(behaviourRequest).first else {
              promise(.failure(.notFoundEntity))
              return
            }
            
            object.setValue(favorite, forKey: "favorite")
            try context.save()
            promise(.success(()))
          } catch {
            promise(.failure(.genericDbError(error.localizedDescription)))
          }
        }
      }
    }
    .eraseToEffect()
  }
  
  func updatePinned
  (id: UUID, pinned: Bool) -> Effect<Void, ErrorCase> {
    Deferred { [context] in
      Future<Void, ErrorCase> { [context] promise in
        context.perform {
          do {
            let idPredicate = NSPredicate(format: "id == %@", id as CVarArg)
            let behaviourRequest: NSFetchRequest<BehaviourEntity>
            
            behaviourRequest = BehaviourEntity.fetchRequest()
            behaviourRequest.predicate = idPredicate
            
            guard let object = try context.fetch(behaviourRequest).first else {
              promise(.failure(.notFoundEntity))
              return
            }
            object.setValue(pinned, forKey: "pinned")
            try context.save()
            promise(.success(()))
          } catch {
            promise(.failure(.genericDbError(error.localizedDescription)))
          }
        }
      }
    }
    .eraseToEffect()
  }
  
  func createEntity(for behaviourId: UUID) -> Effect<Void, ErrorCase> {
    Deferred { [context] in
      Future<Void, ErrorCase> { [context] promise in
        context.perform {
          do {
            let idPredicate = NSPredicate(format: "id == %@", behaviourId as CVarArg)
            let behaviourRequest: NSFetchRequest<BehaviourEntity>
            
            behaviourRequest = BehaviourEntity.fetchRequest()
            behaviourRequest.predicate = idPredicate
            
            guard let behaviour = try context.fetch(behaviourRequest).first else {
              promise(.failure(.notFoundEntity))
              return
            }
            
            let entry = EntryEntity(context: context)
            entry.date = Date()
            behaviour.addToEntries(entry)
            try context.save()
            
            promise(.success(()))
          } catch {
            promise(.failure(.genericDbError(error.localizedDescription)))
          }
        }
      }
    }
    .eraseToEffect()
  }
  
  func deleteLastEntry(for behaviourId: UUID) -> Effect<Void, ErrorCase> {
    Deferred { [context] in
      Future<Void, ErrorCase> { [context] promise in
        context.perform {
          
          do {
            let idPredicate = NSPredicate(format: "id == %@", behaviourId as CVarArg)
            let behaviourRequest: NSFetchRequest<BehaviourEntity>
            
            behaviourRequest = BehaviourEntity.fetchRequest()
            behaviourRequest.predicate = idPredicate
            
            guard let behaviour = try context.fetch(behaviourRequest).first else {
              promise(.failure(.notFoundEntity))
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
            promise(.failure(.genericDbError(error.localizedDescription)))
          }
          
        }
      }
    }
    .eraseToEffect()
  }
}

