//
//  Environment.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import ComposableArchitecture

/// The environment is the depenciens handler
/// here we declare all the needed dependencies
struct AppEnvironment {
  let behavioursRepository: BehaviourRepository
}

extension AppEnvironment {
  static var instance: AppEnvironment {
    .init(
      behavioursRepository: container.behaviourRepository
    )
  }
}
