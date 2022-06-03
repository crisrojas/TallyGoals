//
//  Environment.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 03/06/2022.
//

import ComposableArchitecture

struct AppEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let behavioursRepository: BehaviourRepository
}

extension AppEnvironment {
  static var instance: AppEnvironment {
    .init(
      mainQueue: .main,
      behavioursRepository: container.behaviourRepository
    )
  }
}
