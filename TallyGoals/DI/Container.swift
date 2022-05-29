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
    PersistenceController.preview.container.viewContext
  }
  
  var behaviourRepository: BehaviourRepository {
    .init(context: context)
  }
}
