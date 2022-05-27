import CoreData
let container = Container()

// MARK - Dependency injection, use Swinject instead
final class Container {
  
  var store: AppStore {
    .init(
      initialState: AppState(),
      reducer: appReducer,
      environment: .instance
    )
  }
  
  var context: NSManagedObjectContext {
    PersistenceController.shared.container.viewContext
  }
  
  var behaviourRepository: BehaviourRepository {
    .init(context: context)
  }
}
