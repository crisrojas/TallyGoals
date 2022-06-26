//
//  Error.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 26/06/2022.
//

import Foundation

enum ErrorCase: Error {
  case genericDbError(String)
  case entityLacksProperty
  case notFoundEntity
  
  
  var title: String {
    switch self {
    case .genericDbError(_):
      return "Fetching db error"
    case .entityLacksProperty:
      return "Db entity problem"
    case .notFoundEntity:
      return "Entity not found"
    }
  }
  
  var message: String {
    switch self {
    case .genericDbError(let errorMessage):
      return errorMessage
    case .entityLacksProperty:
      return "Unable to retrieve all the properties for the entity"
    case .notFoundEntity:
      return "Not entity with id"
    }
  }
}
