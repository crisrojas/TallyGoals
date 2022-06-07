//
//  ArrayFilters.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 29/05/2022.
//

import Foundation

extension Array where Element == BehaviourEntity {
  
  var defaultFilter: Self {
    self
      .filter { !$0.archived }
      .filter { !$0.pinned }
      .sorted(by: { $0.name ?? "" < $1.name ?? "" })
      .sorted(by: { $0.emoji ?? ""  < $1.emoji ?? "" })
  }
  
  var pinnedFilter: Self {
    self
      .filter { !$0.archived }
      .filter { $0.pinned }
      .sorted(by: { $0.name ?? "" < $1.name ?? "" })
      .sorted(by: { $0.emoji ?? "" < $1.emoji ?? "" })
  }
}
