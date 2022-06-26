//
//  Persistence.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 27/05/2022.
//

import CoreData

struct PersistenceController {
  
  static let shared = PersistenceController()
  
  struct MockBehaviour {
    let id = UUID()
    let emoji: String
    let name: String
    let archived: Bool
    let favorite: Bool
    let pinned: Bool
  }
  
  static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    
    let initBehaviours = [
      MockBehaviour(
        emoji: "💧",
        name: "Éteindre devices",
        archived: false,
        favorite: false,
        pinned: false
      ),
      MockBehaviour(
        emoji: "💪",
        name: "Resister une tentation",
        archived: false,
        favorite: true,
        pinned: true
      ),
      MockBehaviour(
        emoji: "🥗",
        name: "Manger keto" ,
        archived: true,
        favorite: false,
        pinned: true
      ),
      MockBehaviour(
        emoji: "💪",
        name: "Retarder récompense",
        archived: false,
        favorite: false,
        pinned: true
      ),
      MockBehaviour(
        emoji: "👔",
        name: "Repasser vêtements",
        archived: false,
        favorite: false,
        pinned: true
      ),
      MockBehaviour(
        emoji: "⏰",
        name: "Se coucher à 22:30",
        archived: false,
        favorite: false,
        pinned: true
      ),
      MockBehaviour(
        emoji: "💧",
        name: "Planifier le lendemain",
        archived: false,
        favorite: false,
        pinned: true
      ),
      MockBehaviour(
        emoji: "🙏",
        name: "Jeûne",
        archived: false,
        favorite: false,
        pinned: true
      ),
      MockBehaviour(
        emoji: "💧",
        name: "Éteindre le wifi",
        archived: false,
        favorite: false,
        pinned: true
      ),
      MockBehaviour(
        emoji: "⏰",
        name: "Se lever à 7",
        archived: false,
        favorite: false,
        pinned: false
      ),
      MockBehaviour(
        emoji: "⏰",
        name: "Se lever dès que l'alarme sonne",
        archived: false,
        favorite: false,
        pinned: false
      ),
      MockBehaviour(
        emoji: "🧽",
        name: "Faire la vaiselle just après manger",
        archived: false,
        favorite: false,
        pinned: false
      ),
      MockBehaviour(
        emoji: "💧",
        name: "Activité sans multitask / pratique déliberée",
        archived: false,
        favorite: false,
        pinned: false
      ),
      MockBehaviour(
        emoji: "🙏",
        name: "Appeler un proche",
        archived: false,
        favorite: false,
        pinned: false
      ),
      MockBehaviour(
        emoji: "🙏",
        name: "Aider quelqu'un",
        archived: false,
        favorite: false,
        pinned: false
      ),
      MockBehaviour(
        emoji: "🥶",
        name: "Douches froides",
        archived: false,
        favorite: false,
        pinned: false
      ),
      MockBehaviour(
        emoji: "🏋️‍♀️",
        name: "Pompes",
        archived: false,
        favorite: false,
        pinned: false
      ),
      MockBehaviour(
        emoji: "🏋️‍♀️",
        name: "Tractions",
        archived: false,
        favorite: false,
        pinned: false
      ),
      MockBehaviour(
        emoji: "🙏",
        name: "Respirer avant d'agir",
        archived: false,
        favorite: false,
        pinned: false
      ),
    ]
    
    initBehaviours.forEach { behaviour in
      let entity = BehaviourEntity(context: viewContext)
      entity.id = behaviour.id
      entity.emoji = behaviour.emoji
      entity.name = behaviour.name
      entity.archived = behaviour.archived
      entity.favorite = behaviour.favorite
      entity.pinned = behaviour.pinned
      viewContext.perform {
        try! viewContext.save()
      }
    }
    
    return result
  }()
  
  let container: NSPersistentCloudKitContainer
  
  init(inMemory: Bool = false) {
    
    container = NSPersistentCloudKitContainer(name: "TallyGoals")
    
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
  }
}
