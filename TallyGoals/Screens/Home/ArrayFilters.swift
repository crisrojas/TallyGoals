//
//  ArrayFilters.swift
//  TallyGoals
//
//  Created by Cristian Rojas on 29/05/2022.
//

import Foundation

extension Array where Element == Behaviour {
  
  var defaultFilter: Self {
    self
      .filter { !$0.archived }
      .filter { !$0.pinned }
      .sorted(by: { $0.name < $1.name })
      .sorted(by: { $0.emoji < $1.emoji })
    //.sorted(by: { $0.pinned && !$1.pinned })
  }
  
  var pinnedFilter: Self {
    self
      .filter { !$0.archived }
      .filter { $0.pinned }
      .sorted(by: { $0.name < $1.name })
      .sorted(by: { $0.emoji < $1.emoji })
  }
}
