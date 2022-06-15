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
    let emoji: String
    let name: String
    let archived: Bool
    let favorite: Bool
    let pinned: Bool
    let color: Int
  }
  
  
  static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    
    let initBehaviours = [
      MockBehaviour(
        emoji: "💧",
        name: "Desconectar iMac",
        archived: false,
        favorite: false,
        pinned: false,
        color: 1
      ),
      MockBehaviour(
        emoji: "💪",
        name: "Resistir tentacion",
        archived: false,
        favorite: true,
        pinned: true,
        color: 0
      ),
      MockBehaviour(
        emoji: "🥗",
        name: "Comer ceto" ,
        archived: true,
        favorite: false,
        pinned: true,
        color: 2
      ),
      MockBehaviour(
        emoji: "💪",
        name: "Retrasar recompensa",
        archived: false,
        favorite: false,
        pinned: true,
        color: 3
      ),
      MockBehaviour(
        emoji: "👔",
        name: "Aplanchar ropdd",
        archived: false,
        favorite: false,
        pinned: true,
        color: 4
      ),
      MockBehaviour(
        emoji: "⏰",
        name: "Acostarme a las 22:30",
        archived: false,
        favorite: false,
        pinned: true,
        color: 5
      ),
      MockBehaviour(
        emoji: "💧",
        name: "Planificar el día siguiente",
        archived: false,
        favorite: false,
        pinned: true,
        color: 6
      ),
      MockBehaviour(
        emoji: "🙏",
        name: "Ayuno",
        archived: false,
        favorite: false,
        pinned: true,
        color: 7
      ),
      MockBehaviour(
        emoji: "💧",
        name: "Apagar el wifi",
        archived: false,
        favorite: false,
        pinned: true,
        color: 8
      ),
      MockBehaviour(
        emoji: "⏰",
        name: "Levantarme a las 7",
        archived: false,
        favorite: false,
        pinned: false,
        color: 9
      ),
      MockBehaviour(
        emoji: "💪",
        name: "Trabajar al llegar a casa",
        archived: false,
        favorite: false,
        pinned: false,
        color: 10
      ),
      MockBehaviour(
        emoji: "⏰",
        name: "Levantarme sin postergar la alarma",
        archived: false,
        favorite: false,
        pinned: false,
        color: 11
      ),
      MockBehaviour(
        emoji: "💧",
        name: "Recoger antes de acostarme",
        archived: false,
        favorite: false,
        pinned: false,
        color: 12
      ),
      MockBehaviour(
        emoji: "🧽",
        name: "Lavar la losa justo después de comer",
        archived: false,
        favorite: false,
        pinned: false,
        color: 13
      ),
      MockBehaviour(
        emoji: "💧",
        name: "Activité sin multitarea / práctica deliberada",
        archived: false,
        favorite: false,
        pinned: false,
        color: 14
      ),
      MockBehaviour(
        emoji: "🙏",
        name: "Llamar a seres queridos",
        archived: false,
        favorite: false,
        pinned: false,
        color: 15
      ),
      MockBehaviour(
        emoji: "🙏",
        name: "Ayudar a alguien",
        archived: false,
        favorite: false,
        pinned: false,
        color: 16
      ),
      MockBehaviour(
        emoji: "💰",
        name: "Vídeos de youtube",
        archived: false,
        favorite: false,
        pinned: false,
        color: 17
      ),
      MockBehaviour(
        emoji: "🥶",
        name: "Duchas frías",
        archived: false,
        favorite: false,
        pinned: false,
        color: 18
      ),
      MockBehaviour(
        emoji: "🏋️‍♀️",
        name: "Flexiones",
        archived: false,
        favorite: false,
        pinned: false,
        color: 19
      ),
      MockBehaviour(
        emoji: "🏋️‍♀️",
        name: "Dominadas",
        archived: false,
        favorite: false,
        pinned: false,
        color: 20
      ),
      MockBehaviour(
        emoji: "🏋️‍♀️",
        name: "Abdominales",
        archived: false,
        favorite: false,
        pinned: false,
        color: 21
      ),
      MockBehaviour(
        emoji: "🙏",
        name: "Respirar antes de actuar",
        archived: false,
        favorite: false,
        pinned: false,
        color: 22
      ),
    ]
    
    initBehaviours.forEach { behaviour in
      let entity = BehaviourEntity(context: viewContext)
      entity.emoji = behaviour.emoji
      entity.name = behaviour.name
      entity.archived = behaviour.archived
      entity.favorite = behaviour.favorite
      entity.pinned = behaviour.pinned
      entity.color = Int16(behaviour.color)
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
